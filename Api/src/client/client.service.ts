import {
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from "@nestjs/common";
import { RedisService } from "src/common/redis/redis.service";
import { UserRepository } from "src/user/user.repository";
import { ClientRepository } from "./client.repository";
import { ClientPublic, CreateClientSchema, UpdateClientSchema } from "./types";
import { EncryptionKeyService } from "src/common/encryption-key/encryption-key.service";
import {
  aes256GcmEncrypt,
  decomposeEncryptedData,
  formatEncryptedData,
} from "src/core/utils/crypto-utils";
import { decryptEntityFields } from "src/core/utils/decrypt-entity-utils";
import { Client } from "src/common/drizzle/schemas";

@Injectable()
export class ClientService {
  constructor(
    private clientRepository: ClientRepository,
    private redis: RedisService,
    private userRepository: UserRepository,
    private encryptionKeyService: EncryptionKeyService,
  ) {}

  async invalidateClientsCache(): Promise<void> {
    await this.redis.del("clients");
  }

  async createClient(
    userId: string,
    checkName: boolean,
    data: Omit<CreateClientSchema, "encryptedKey" | "userId">,
  ): Promise<ClientPublic | null> {
    const user = await this.userRepository.findById(userId);
    if (!user) {
      throw new NotFoundException("L'utilisateur est introuvable");
    }

    // check if client with same name already exist and return it if exist
    if (checkName) {
      const client = await this.clientRepository.searchByName(
        userId,
        data.name,
      );

      if (client.length > 0) {
        await this.invalidateClientsCache();

        return await this.updateClient(userId, client[0].id, {
          phoneNumber: data.phoneNumber,
        });
      }
    }

    const plainKEK = await this.encryptionKeyService.decryptKEK(userId);
    if (!plainKEK) {
      throw new InternalServerErrorException(
        "Impossible de déchiffrer la Key Encryption Key",
      );
    }

    const generatedDEK = this.encryptionKeyService.generateDEK(plainKEK);
    if (!generatedDEK) {
      throw new InternalServerErrorException(
        "Impossible de générer la Data Encryption Key",
      );
    }

    const { IV, tag, encrypted } = aes256GcmEncrypt(
      data.address,
      generatedDEK.plainDEK,
    );
    const encryptedAddress = formatEncryptedData(IV, encrypted, tag);

    const created = await this.clientRepository.create({
      ...data,
      userId,
      address: encryptedAddress,
      encryptedKey: generatedDEK.encryptedDEK,
    });

    if (!created) return null;

    const { encryptedKey: _, ...clientPublic } = created;

    await this.invalidateClientsCache();

    return clientPublic as ClientPublic;
  }

  async searchClientByName(
    userId: string,
    name: string,
  ): Promise<ClientPublic[]> {
    const cacheKey = `clients:search:${userId}:${name.toLowerCase().trim()}`;
    const cached = await this.redis.get(cacheKey);
    if (cached) {
      return cached as ClientPublic[];
    }

    const clients = await this.clientRepository.searchByName(userId, name);

    const decryptedClients: ClientPublic[] = [];

    for (const client of clients) {
      const decryptedAddress = await decryptEntityFields<Client>(
        client,
        "address",
        this.encryptionKeyService,
      );

      const { encryptedKey: _, ...clientWithoutKey } = client;

      decryptedClients.push({
        ...clientWithoutKey,
        address: decryptedAddress,
      } as ClientPublic);
    }

    await this.redis.set(cacheKey, decryptedClients, 10 * 60);
    return decryptedClients;
  }

  async getAllClients(userId: string): Promise<ClientPublic[]> {
    const clients = await this.clientRepository.findAll(userId);

    const decryptedClients: ClientPublic[] = [];

    for (const client of clients) {
      const decryptedAddress = await decryptEntityFields<Client>(
        client,
        "address",
        this.encryptionKeyService,
      );

      const { encryptedKey: _, ...clientWithoutKey } = client;

      decryptedClients.push({
        ...clientWithoutKey,
        address: decryptedAddress,
      } as ClientPublic);
    }

    return decryptedClients;
  }

  async getClientById(userId: string, clientId: string): Promise<ClientPublic> {
    const client = await this.clientRepository.findById(userId, clientId);

    if (!client) {
      throw new NotFoundException("Le client est introuvable");
    }

    const decryptedAddress = await decryptEntityFields<Client>(
      client,
      "address",
      this.encryptionKeyService,
    );

    const { encryptedKey: _, ...clientWithoutKey } = client;

    return {
      ...clientWithoutKey,
      address: decryptedAddress,
    } as ClientPublic;
  }

  // update client infos
  async updateClient(
    userId: string,
    clientId: string,
    data: UpdateClientSchema,
  ): Promise<ClientPublic | null> {
    const client = await this.clientRepository.findById(userId, clientId);

    if (!client) {
      throw new NotFoundException("Le client est introuvable");
    }

    const dataToUpdate = {
      ...data,
    };

    // re-encrypt address if updated
    if (data.address) {
      const plainKEK = await this.encryptionKeyService.decryptKEK(
        client.encryptedKey!,
      );
      if (!plainKEK) {
        throw new InternalServerErrorException(
          "Impossible de déchiffrer la Key Encryption Key",
        );
      }

      // decrypt DEK
      const decomposedDEK = decomposeEncryptedData(client.encryptedKey!);
      const plainDEK = this.encryptionKeyService.decryptDEK({
        Dek: decomposedDEK.encrypted as string,
        Kek: plainKEK,
        IV: decomposedDEK.IV,
        tag: decomposedDEK.tag,
      });

      if (!plainDEK) {
        throw new InternalServerErrorException(
          "Impossible de déchiffrer la Data Encryption Key",
        );
      }

      const { IV, tag, encrypted } = aes256GcmEncrypt(data.address, plainDEK);
      const address = formatEncryptedData(IV, encrypted, tag);
      dataToUpdate.address = address;
    }

    const updatedClient = await this.clientRepository.update(
      userId,
      dataToUpdate,
    );

    if (!updatedClient) {
      throw new InternalServerErrorException(
        "Impossible de mettre à jour les informations du client",
      );
    }

    const decryptedAddress = await decryptEntityFields<Client>(
      updatedClient,
      "address",
      this.encryptionKeyService,
    );

    const { encryptedKey: _, ...clientWithoutKey } = updatedClient;

    await this.invalidateClientsCache();

    return {
      ...clientWithoutKey,
      address: decryptedAddress,
    };
  }
}

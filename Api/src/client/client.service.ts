import {
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from "@nestjs/common";
import { RedisService } from "src/common/redis/redis.service";
import { UserRepository } from "src/user/user.repository";
import { ClientRepository } from "./client.repository";
import { ClientPublic, CreateClientSchema } from "./types";
import { EncryptionKeyService } from "src/common/encryption-key/encryption-key.service";
import {
  aes256GcmEncrypt,
  formatEncryptedData,
} from "src/core/utils/crypto-utils";

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
    data: Omit<CreateClientSchema, "encryptedKey" | "userId">,
  ): Promise<ClientPublic | null> {
    const user = await this.userRepository.findById(userId);
    if (!user) {
      throw new NotFoundException("L'utilisateur est introuvable");
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
    return clientPublic as ClientPublic;
  }

  async searchClientByName(userId: string, name: string): Promise<ClientPublic[]> {
    const cacheKey = `clients:search:${userId}:${name.toLowerCase().trim()}`;

    const cached = await this.redis.get(cacheKey);
    if (cached) {
      return cached as ClientPublic[];
    }

    const clients = await this.clientRepository.searchByName(userId, name);

    const safeClients: ClientPublic[] = clients.map(({ encryptedKey: _, ...c }) => c as ClientPublic);

    await this.redis.set(cacheKey, safeClients, 10 * 60);

    return safeClients;
  }
}

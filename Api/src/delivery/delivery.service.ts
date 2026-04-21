import {
  Injectable,
  InternalServerErrorException,
  Logger,
  NotFoundException,
} from "@nestjs/common";
import {
  CreateDeliverySchema,
  DeliveryPublic,
  DeliveryWithArticles,
  IGetAllDeliveriesQuery,
} from "./types";
import { DeliveryRepository } from "./delivery.repository";
import { UserRepository } from "src/user/user.repository";
import { EncryptionKeyService } from "src/common/encryption-key/encryption-key.service";
import {
  aes256GcmDecrypt,
  aes256GcmEncrypt,
  decomposeEncryptedData,
  formatEncryptedData,
} from "src/core/utils/crypto-utils";

@Injectable()
export class DeliveryService {
  private readonly logger = new Logger(DeliveryService.name);

  constructor(
    private deliveryRepository: DeliveryRepository,
    private userRepository: UserRepository,
    private encryptionKeyService: EncryptionKeyService,
  ) {}

  // create new delivery with its items
  async createDelivery(
    userId: string,
    data: Omit<CreateDeliverySchema, "userId" | "deliveryId" | "encryptedKey">,
  ) {
    const user = await this.userRepository.findById(userId);

    if (!user) {
      throw new NotFoundException("L'utilisateur est introuvable");
    }

    //decrypt KEK
    const plainKEK = await this.encryptionKeyService.decryptKEK(userId);

    if (!plainKEK) {
      throw new InternalServerErrorException(
        "Impossible de déchiffrer le Key encryption Key",
      );
    }

    // generate Data Encryption Key and encrypt address
    const generatedDEK = this.encryptionKeyService.generateDEK(plainKEK);

    const { IV, tag, encrypted } = aes256GcmEncrypt(
      data.address,
      generatedDEK!.plainDEK,
    );

    const encryptedAddress = formatEncryptedData(IV, encrypted, tag);

    // format delivery name
    const datePart = new Date()
      .toLocaleDateString()
      .split("/")
      .reverse()
      .join("");

    const deliveryId = `RP-${datePart}  `;

    await this.deliveryRepository.create({
      ...data,
      deliveryId,
      userId: user.id,
      address: encryptedAddress,
      encryptedKey: generatedDEK!.encryptedDEK,
    });
  }

  // get all deliveries
  async getAllDeliveries(
    userId: string,
    filter?: IGetAllDeliveriesQuery,
  ): Promise<{
    total: number;
    deliveries: DeliveryPublic[];
  }> {
    const paginatedDeliveries = await this.deliveryRepository.findAll(
      userId,
      filter,
    );

    const decryptedDeliveries: DeliveryPublic[] = [];

    for (const delivery of paginatedDeliveries.deliveries) {
      if (!delivery.address) {
        decryptedDeliveries.push(delivery);
        continue;
      }

      const decryptedDelivery = await this.decryptDeliveryAddress(delivery);

      decryptedDeliveries.push(decryptedDelivery);
    }

    return {
      total: paginatedDeliveries.count,
      deliveries: decryptedDeliveries,
    };
  }

  // get delivery by its ID
  async getDeliveryById(
    userId: string,
    deliveryId: string,
  ): Promise<DeliveryPublic> {
    const delivery = await this.deliveryRepository.findById(userId, deliveryId);

    if (!delivery) {
      throw new NotFoundException("La livraison est introuvable");
    }

    return await this.decryptDeliveryAddress(delivery);
  }

  // helper for decrypting address
  private async decryptDeliveryAddress(delivery: DeliveryWithArticles) {
    // decrypt KEK
    let plainKEK: string | null;
    try {
      plainKEK = await this.encryptionKeyService.decryptKEK(delivery.userId);
    } catch (err) {
      this.logger.error("Failed to decrypt KEK :", err);
      throw new InternalServerErrorException(
        "Impossible de déchiffrer le Key encryption Key",
      );
    }

    if (!plainKEK) {
      throw new InternalServerErrorException(
        "Impossible de déchiffrer le Key encryption Key",
      );
    }

    // decrypt DEK
    const decomposedDEK = decomposeEncryptedData(delivery.encryptedKey!);
    const plainDEK = this.encryptionKeyService.decryptDEK({
      Dek: decomposedDEK.encrypted as string,
      Kek: plainKEK,
      IV: decomposedDEK.IV,
      tag: decomposedDEK.tag,
    });

    // decrypt address
    const decomposedEncryptedAddress = decomposeEncryptedData(delivery.address);
    const decryptedAddress = aes256GcmDecrypt({
      key: plainDEK!,
      encrypted: decomposedEncryptedAddress.encrypted,
      IV: decomposedEncryptedAddress.IV,
      tag: decomposedEncryptedAddress.tag,
    });

    const { encryptedKey, ...deliveryWithoutKey } = delivery;

    return {
      ...deliveryWithoutKey,
      address: decryptedAddress,
    };
  }
}

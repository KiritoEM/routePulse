import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
  Logger,
  NotFoundException,
} from "@nestjs/common";
import {
  ArticleWithFile,
  ArticleWithImageResult,
  CreateDeliverySchema,
  CreateDeliveryServiceSchema,
  DeliveryPublic,
  DeliveryResult,
  IGetAllDeliveriesQuery,
  UpdateDeliverySchema,
  UpdateDeliveryWithStatus,
  ValidateDeliverySchema,
  ValidateDeliveryServiceSchema,
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
import { SupabaseService } from "src/common/supabase/supabase.service";
import { Client, Delivery } from "src/common/drizzle/schemas";
import { decryptEntityFields } from "src/core/utils/decrypt-entity-utils";
import { generateRandomDigitalNumber } from "src/core/utils/random-number-utils";
import { RedisService } from "src/common/redis/redis.service";
import {
  DeliveriesCountType,
  DeliveryStatus,
} from "src/core/constants/enums/delivery-enums";

@Injectable()
export class DeliveryService {
  private readonly logger = new Logger(DeliveryService.name);
  private SIGNED_URL_DURATION: number = 60 * 60 * 24; // 24 hours

  constructor(
    private deliveryRepository: DeliveryRepository,
    private userRepository: UserRepository,
    private encryptionKeyService: EncryptionKeyService,
    private storageService: SupabaseService,
    private redis: RedisService,
  ) {}

  // resolve article image urls, a storage failure must not break the response
  private async resolveArticlesImageUrl(
    articles: ArticleWithImageResult[],
  ): Promise<ArticleWithImageResult[]> {
    const resolvedArticles: ArticleWithImageResult[] = [];

    for (const article of articles) {
      if (!article.image) {
        resolvedArticles.push(article);
        continue;
      }

      const cacheKey = "article:url:" + article.id;
      const cachedPublicUrl = (await this.redis.get(cacheKey)) as {
        publicUrl: string;
      };

      if (cachedPublicUrl) {
        resolvedArticles.push({
          ...article,
          image: { ...article.image, path: cachedPublicUrl.publicUrl },
        });
        continue;
      }

      try {
        const publicUrl = await this.storageService.createSignedURL(
          article.image.path!,
          this.SIGNED_URL_DURATION,
        );

        // cache publicURL
        await this.redis.set(
          cacheKey,
          { publicUrl },
          this.SIGNED_URL_DURATION,
        );

        resolvedArticles.push({
          ...article,
          image: { ...article.image, path: publicUrl },
        });
      } catch (err) {
        this.logger.warn(
          `Failed to sign image url of article ${article.id}: ${err}`,
        );

        resolvedArticles.push(article);
      }
    }

    return resolvedArticles;
  }

  // create new delivery with its items
  async createDelivery(
    userId: string,
    data: Omit<
      CreateDeliveryServiceSchema,
      "userId" | "deliveryId" | "encryptedKey"
    >,
  ): Promise<Pick<Delivery, "id" | "deliveryId"> | null> {
    const user = await this.userRepository.findById(userId);

    if (!user) {
      throw new NotFoundException("L'utilisateur est introuvable");
    }

    // Sync with mobile(UPDATE)
    if (data.checkIsExist && data.existingId) {
      const delivery = await this.deliveryRepository.findById(
        userId,
        data.existingId,
      );

      if (delivery) {
        const {
          articles,
          checkIsExist,
          existingId,
          existingDeliveryId,
          ...deliveryUpdateData
        } = data;

        const updatedDelivery = await this.updateDelivery(
          user.id,
          delivery.id,
          deliveryUpdateData,
        );

        return {
          id: updatedDelivery.id,
          deliveryId: updatedDelivery.deliveryId,
        };
      }
    }

    // Decrypt KEK
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

    const formatedArticles: ArticleWithFile[] = [];

    // save files to storage
    for (let item of data.articles) {
      const fileName = `${Date.now()}-${item.name.split(" ").join("_")}-${generateRandomDigitalNumber({ length: 4 }).toString()}`;

      if (item?.file) {
        const { path } = await this.storageService.uploadFile({
          file: Buffer.from(item.file.file, "base64"),
          fileMimetype: item.file.mimeType,
          originalFileName: fileName,
        });

        formatedArticles.push({
          ...item,
          file: {
            path,
            fileName,
            mimeType: item.file.mimeType,
            size: item.file.size,
          },
        });
      } else {
        formatedArticles.push({ ...item, file: null });
      }
    }

    // format delivery name
    let deliveryId: string = "RP";

    if (!data.existingDeliveryId) {
      const datePart = new Date()
        .toLocaleDateString()
        .split("/")
        .reverse()
        .join("");

      deliveryId = `RP-${datePart}-${generateRandomDigitalNumber({ length: 4 })}`;
    } else {
      deliveryId = data.existingDeliveryId!;
    }

    const createdDelivery = await this.deliveryRepository.create({
      ...data,
      deliveryId,
      userId: user.id,
      address: encryptedAddress,
      encryptedKey: generatedDEK!.encryptedDEK,
      articles: formatedArticles,
    });

    if (!createdDelivery) {
      return null;
    }

    return {
      id: createdDelivery?.id,
      deliveryId,
    };
  }

  // validate delivery
  async validateDelivery(
    userId: string,
    deliveryId: string,
    data: ValidateDeliveryServiceSchema,
  ) {
    const delivery = await this.deliveryRepository.findById(userId, deliveryId);

    if (!delivery) {
      throw new NotFoundException("La livraison est introuvable");
    }

    let filePath: string | null = null;

    // save file to storage and return the bucket-path
    const fileName = `proof-${deliveryId}-${Date.now()}`;

    if (data.file) {
      const { path } = await this.storageService.uploadFile({
        file: Buffer.from(data.file.file, "base64"),
        fileMimetype: data.file.mimeType,
        originalFileName: fileName,
      });

      filePath = path;
    }

    await this.deliveryRepository.changeStatusAndAddPictureProof(
      userId,
      deliveryId,
      {
        totalKm: data.totalKm,
        deliveredAt: data.deliveredAt,
        file: filePath
          ? {
              path: filePath,
              fileName: fileName,
              mimeType: data.file!.mimeType,
              size: data.file!.size,
            }
          : null,
      },
    );
  }

  // update delivery
  async updateDelivery(
    userId: string,
    deliveryId: string,
    data: UpdateDeliverySchema,
  ): Promise<Pick<Delivery, "id" | "deliveryId">> {
    const existingDelivery = await this.deliveryRepository.findById(
      userId,
      deliveryId,
    );

    if (!existingDelivery) {
      throw new NotFoundException(
        "La livraison à mettre à jour est introuvable",
      );
    }

    // Decrypt KEK
    const plainKEK = await this.encryptionKeyService.decryptKEK(userId);
    if (!plainKEK) {
      throw new InternalServerErrorException("Impossible de déchiffrer le KEK");
    }

    // Update Address
    let encryptedAddress = existingDelivery.address;

    if (data.address) {
      if (data.address !== existingDelivery.address) {
        const generatedDEK = this.encryptionKeyService.generateDEK(plainKEK);
        const { IV, tag, encrypted } = aes256GcmEncrypt(
          data.address,
          generatedDEK!.plainDEK,
        );
        encryptedAddress = formatEncryptedData(IV, encrypted, tag);
      }
    }

    // Update delivery
    const updatedDelivery = await this.deliveryRepository.update(deliveryId, {
      ...data,
      userId: userId,
      address: encryptedAddress,
    });

    if (!updatedDelivery) {
      throw new InternalServerErrorException(
        "Échec de la mise à jour de la livraison",
      );
    }

    return {
      id: updatedDelivery.id,
      deliveryId: updatedDelivery.deliveryId,
    };
  }

  // get all deliveries
  async getAllDeliveries(
    userId: string,
    filter?: IGetAllDeliveriesQuery,
  ): Promise<{ total: number; deliveries: DeliveryPublic[] }> {
    const paginatedDeliveries = await this.deliveryRepository.findAll(
      userId,
      filter,
    );
    const decryptedDeliveries: DeliveryPublic[] = [];

    for (const delivery of paginatedDeliveries.deliveries) {
      const { encryptedKey, ...deliveryWithoutKey } = delivery;

      if (!delivery.address) {
        decryptedDeliveries.push(deliveryWithoutKey);
        continue;
      }

      const decryptedAddress = await decryptEntityFields<DeliveryResult>(
        delivery,
        "address",
        this.encryptionKeyService,
        userId,
      );

      // change path of the article from supabase
      const updatedArticle = await this.resolveArticlesImageUrl(
        delivery.articles,
      );

      decryptedDeliveries.push({
        ...deliveryWithoutKey,
        address: decryptedAddress,
        articles: updatedArticle,
      });
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

    const decryptedAddress = await decryptEntityFields<DeliveryResult>(
      delivery,
      "address",
      this.encryptionKeyService,
      userId,
    );
    const { encryptedKey, ...deliveryWithoutKey } = delivery;

    // change path of the article from supabase
    const updatedArticles = await this.resolveArticlesImageUrl(
      delivery.articles,
    );

    return {
      ...deliveryWithoutKey,
      address: decryptedAddress,
      articles: updatedArticles,
    };
  }

  // start delivery
  async startDelivery(deliveryId: string) {
    await this.deliveryRepository.updateStatus(deliveryId, {
      fromStatus: DeliveryStatus.PENDING,
      toStatus: DeliveryStatus.IN_PROGRESS,
    });
  }

  // cancel delivery
  async cancelDelivery(userId: string, deliveryId: string, reason: string) {
    const delivery = await this.deliveryRepository.findById(userId, deliveryId);

    if (!delivery) {
      throw new NotFoundException("Livraison introuvable");
    }

    await this.deliveryRepository.updateStatus(deliveryId, {
      fromStatus: delivery.status as DeliveryStatus,
      toStatus: DeliveryStatus.CANCELLED,
      cancelReason: reason,
    });
  }
  // repot delivery
  async reportDelivery(
    userId: string,
    deliveryId: string,
    newDate: string,
    timeSlotStart?: string,
    timeSlotEnd?: string,
  ) {
    const delivery = await this.deliveryRepository.findById(userId, deliveryId);

    if (!delivery) {
      throw new NotFoundException("Livraison introuvable");
    }

    // keep the current slot if none is given
    const start = timeSlotStart ?? delivery.timeSlotStart;
    const end = timeSlotEnd ?? delivery.timeSlotEnd;

    this.checkReportSchedule(newDate, start, end);

    await this.deliveryRepository.updateStatus(deliveryId, {
      fromStatus: delivery.status as DeliveryStatus,
      toStatus: DeliveryStatus.REPORTED,
      date: newDate.split("T")[0],
      timeSlotStart: start,
      timeSlotEnd: end,
    });
  }

  // new schedule must start in the future and end after it starts
  private checkReportSchedule(date: string, start: string, end: string) {
    const toMinutes = (time: string) => {
      const [hours, minutes] = time.split(":");
      return Number(hours) * 60 + Number(minutes);
    };

    if (toMinutes(end) <= toMinutes(start)) {
      throw new BadRequestException(
        "L'heure de fin doit être après l'heure de début",
      );
    }

    const scheduledAt = new Date(`${date.split("T")[0]}T${start}`);

    if (Number.isNaN(scheduledAt.getTime())) {
      throw new BadRequestException("La nouvelle date est invalide");
    }

    if (scheduledAt.getTime() <= Date.now()) {
      throw new BadRequestException(
        "Le nouveau créneau doit être dans le futur",
      );
    }
  }

  // get deliveries count by a specific status
  async getDeliveriesCount(userId: string, type: DeliveriesCountType) {
    return await this.deliveryRepository.fetchDeliveriesCount(userId, type);
  }

  // fetch deliveries of the day
  async fetchTodayDeliveries(
    userId: string,
    limit?: number,
    status?: DeliveryStatus,
  ): Promise<DeliveryPublic[]> {
    const deliveries = await this.deliveryRepository.fetchTodayDeliveries(
      userId,
      limit,
      status,
    );

    const decryptedDeliveries: DeliveryPublic[] = [];

    for (const delivery of deliveries) {
      const { encryptedKey, ...deliveryWithoutKey } = delivery;

      if (!delivery.address) {
        decryptedDeliveries.push(deliveryWithoutKey);
        continue;
      }

      const decryptedAddress = await decryptEntityFields<DeliveryResult>(
        delivery,
        "address",
        this.encryptionKeyService,
        userId,
      );

      const updatedArticles = await this.resolveArticlesImageUrl(
        delivery.articles,
      );

      decryptedDeliveries.push({
        ...deliveryWithoutKey,
        address: decryptedAddress,
        articles: updatedArticles,
      });
    }

    return decryptedDeliveries;
  }

  // helper for decrypting address
  private async decryptDeliveryAddress(delivery: DeliveryResult) {
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
  }
}

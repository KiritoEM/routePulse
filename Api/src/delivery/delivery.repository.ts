import { Inject, Injectable } from "@nestjs/common";
import { DRIZZLE_PROVIDER_KEY } from "src/core/constants/dependencies-constants";
import * as drizzleProvider from "src/common/drizzle/drizzle.provider";
import {
  CreateDeliverySchema,
  DeliveryResult,
  IGetAllDeliveriesQuery,
  UpdateDeliverySchema,
  UpdateDeliveryWithStatus,
  ValidateDeliverySchema,
} from "./types";
import {
  deliveries,
  Delivery,
  deliveryHistories,
  deliveryItems,
  files,
} from "src/common/drizzle/schemas";
import { and, asc, count, desc, eq, or, SQL } from "drizzle-orm";
import { SortEnums } from "src/core/constants/enums/sort-enums";
import {
  DeliveriesCountType,
  DeliveryStatus,
} from "src/core/constants/enums/delivery-enums";

@Injectable()
export class DeliveryRepository {
  constructor(
    @Inject(DRIZZLE_PROVIDER_KEY) private db: drizzleProvider.DrizzleDB,
  ) {}

  async create(data: CreateDeliverySchema): Promise<Delivery | null> {
    return await this.db.transaction(async (tx) => {
      const { articles, ...deliveryData } = data;

      const [createdDelivery] = await tx
        .insert(deliveries)
        .values(deliveryData)
        .returning();

      if (!createdDelivery?.id) {
        tx.rollback();
        return null;
      }

      for (const item of articles) {
        const { file, ...articleWithoutFile } = item;

        // create articles
        const [createdArticle] = await tx
          .insert(deliveryItems)
          .values({ ...articleWithoutFile, deliveryId: createdDelivery.id })
          .returning();

        if (!createdArticle?.id) {
          tx.rollback();
          return null;
        }

        // create files
        if (file && file?.path) {
          await tx.insert(files).values({
            ...file,
            deliveryItemId: createdArticle.id,
            userId: data.userId,
            path: file.path,
          });
        }
      }

      // create history
      await tx.insert(deliveryHistories).values({
        deliveryId: createdDelivery.id,
        toStatus: DeliveryStatus.PENDING,
      });

      return createdDelivery;
    });
  }

  async findById(userId: string, id: string): Promise<DeliveryResult | null> {
    const result = await this.db.query.deliveries.findFirst({
      where: and(eq(deliveries.id, id), eq(deliveries.userId, userId)),
      with: {
        articles: { with: { image: true } },
        client: {
          columns: {
            encryptedKey: false,
            address: false,
            location: false,
          },
        },
      },
    });

    return result ?? null;
  }

  async findAll(
    userId: string,
    filter?: IGetAllDeliveriesQuery,
  ): Promise<{ count: number; deliveries: DeliveryResult[] }> {
    const todayDate = new Date().toISOString().split("T")[0];

    const conditions = and(
      eq(deliveries.userId, userId),
      eq(deliveries.deliveryDate, todayDate),
      filter?.status ? eq(deliveries.status, filter.status) : undefined,
    );

    const [{ total }] = await this.db
      .select({ total: count() })
      .from(deliveries)
      .where(conditions);

    let orderBy: SQL;
    switch (filter?.sort) {
      case SortEnums.TIME_SLOT:
        orderBy = desc(deliveries.timeSlotStart);
        break;
      case SortEnums.CREATION_DATE:
        orderBy = desc(deliveries.createdAt);
        break;
      default:
        orderBy = desc(deliveries.createdAt);
    }

    const result = await this.db.query.deliveries.findMany({
      where: conditions,
      with: {
        articles: {
          with: {
            image: true,
          },
        },
        client: {
          columns: {
            encryptedKey: false,
            address: false,
            location: false,
          },
        },
      },
      limit: filter?.limit,
      offset:
        filter?.page && filter?.limit
          ? (filter.page - 1) * filter.limit
          : undefined,
      orderBy: [orderBy],
    });

    return {
      count: total,
      deliveries: result,
    };
  }

  async fetchTodayDeliveries(
    userId: string,
    limit: number = 5,
    status: DeliveryStatus = DeliveryStatus.PENDING,
  ): Promise<DeliveryResult[]> {
    const todayDate = new Date().toISOString().split("T")[0];

    const conditions = and(
      eq(deliveries.userId, userId),
      eq(deliveries.deliveryDate, todayDate),
      eq(deliveries.status, status),
    );

    return await this.db.query.deliveries.findMany({
      where: conditions,
      with: {
        articles: {
          with: {
            image: true,
          },
        },
        client: {
          columns: {
            encryptedKey: false,
            address: false,
            location: false,
          },
        },
      },
      limit,
      orderBy: [asc(deliveries.timeSlotStart)],
    });
  }

  async changeStatusAndAddPictureProof(
    userId: string,
    deliveryId: string,
    data: ValidateDeliverySchema,
  ) {
    await this.db.transaction(async (tx) => {
      // upload picture proof
      if (data?.file && data.file.path) {
        await tx.insert(files).values({ ...data.file, userId: userId });
      } else {
        tx.rollback();
      }

      // change status of delivery
      await tx
        .update(deliveries)
        .set({
          status: DeliveryStatus.DELIVERED,
          totalKm: data.totalKm,
          deliveredAt: data.deliveredAt,
        })
        .where(eq(deliveries.id, deliveryId));
    });
  }

  async fetchDeliveriesCount(
    userId: string,
    type: DeliveriesCountType,
  ): Promise<number> {
    const todayDate = new Date().toISOString().split("T")[0];

    const query = this.db.select({ count: count() }).from(deliveries);

    const baseConditions = and(
      eq(deliveries.userId, userId),
      eq(deliveries.deliveryDate, todayDate),
    );

    if (type === DeliveriesCountType.TODO) {
      query.where(
        and(
          baseConditions,
          or(
            eq(deliveries.status, "pending"),
            eq(deliveries.status, "in_progress"),
          ),
        ),
      );
    } else if (type == DeliveriesCountType.FINISHED) {
      query.where(
        and(
          baseConditions,
          eq(deliveries.status, "delivered"),
          eq(deliveries.userId, userId),
        ),
      );
    }

    return query.then((result) => result[0]?.count);
  }

  async update(
    deliveryId: string,
    data: UpdateDeliverySchema,
  ): Promise<Delivery | null> {
    const result = await this.db
      .update(deliveries)
      .set(data)
      .where(eq(deliveries.deliveryId, deliveryId))
      .returning();

    return result[0] ?? null;
  }

  async updateStatus(
    id: string,
    data: UpdateDeliveryWithStatus,
  ): Promise<Delivery | null> {
    return await this.db.transaction(async (tx) => {
      const dataToUpdate = {
        status: data.toStatus,
      };

      if (data.date) {
        dataToUpdate["deliveryDate"] = data.date;
      }

      if (data.cancelReason) {
        dataToUpdate["cancelReason"] = data.cancelReason;
      }

      const [updatedDelivery] = await tx
        .update(deliveries)
        .set(dataToUpdate)
        .where(eq(deliveries.id, id))
        .returning();

      if (!updatedDelivery?.id) {
        tx.rollback();
        return null;
      }

      // add history
      await tx.insert(deliveryHistories).values({
        deliveryId: updatedDelivery.id,
        fromStatus: data.fromStatus,
        toStatus: data.toStatus,
      });

      return updatedDelivery;
    });
  }
  async delete(deliveryId: string): Promise<void> {
    await this.db
      .delete(deliveries)
      .where(eq(deliveries.deliveryId, deliveryId));
  }
}

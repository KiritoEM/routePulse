import { Inject, Injectable } from "@nestjs/common";
import { DRIZZLE_PROVIDER_KEY } from "src/core/constants/dependencies-constants";
import * as drizzleProvider from "src/common/drizzle/drizzle.provider";
import {
  CreateDeliverySchema,
  DeliveryResult,
  IGetAllDeliveriesQuery,
  UpdateDeliverySchema,
} from "./types";
import {
  deliveries,
  Delivery,
  deliveryItems,
  files,
} from "src/common/drizzle/schemas";
import { and, asc, count, desc, eq, SQL } from "drizzle-orm";
import { SortEnums } from "src/core/constants/enums/sort-enums";

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

        const [createdArticle] = await tx
          .insert(deliveryItems)
          .values({ ...articleWithoutFile, deliveryId: createdDelivery.id })
          .returning();

        if (!createdArticle?.id) {
          tx.rollback();
          return null;
        }

        if (file && file?.path) {
          await tx.insert(files).values({
            ...file,
            deliveryItemId: createdArticle.id,
            userId: data.userId,
            path: file.path,
          });
        }
      }

      return createdDelivery;
    });
  }

  async findById(userId: string, id: string): Promise<DeliveryResult | null> {
    const result = await this.db.query.deliveries.findFirst({
      where: and(eq(deliveries.id, id), eq(deliveries.userId, userId)),
      with: { articles: { with: { image: true } }, client: true },
    });

    return result ?? null;
  }

  async findAll(
    userId: string,
    filter?: IGetAllDeliveriesQuery,
  ): Promise<{ count: number; deliveries: DeliveryResult[] }> {
    const conditions = and(
      eq(deliveries.userId, userId),
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
        orderBy = asc(deliveries.createdAt);
    }

    const result = await this.db.query.deliveries.findMany({
      where: conditions,
      with: {
        articles: {
          with: {
            image: true,
          },
        },
        client: true,
      },
      limit: filter?.limit,
      offset:
        filter?.page && filter?.limit
          ? (filter.page - 1) * filter.limit
          : undefined,
    });

    return {
      count: total,
      deliveries: result,
    };
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

  async delete(deliveryId: string): Promise<void> {
    await this.db
      .delete(deliveries)
      .where(eq(deliveries.deliveryId, deliveryId));
  }
}

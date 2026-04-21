import { Inject, Injectable } from "@nestjs/common";
import { DRIZZLE_PROVIDER_KEY } from "src/core/constants/dependencies-constants";
import * as drizzleProvider from "src/common/drizzle/drizzle.provider";
import {
  CreateDeliverySchema,
  DeliveryWithArticles,
  IGetAllDeliveriesQuery,
  UpdateDeliverySchema,
} from "./types";
import { deliveries, deliveryItems, files } from "src/common/drizzle/schemas";
import {
  and,
  asc,
  count,
  desc,
  eq,
  getTableColumns,
  sql,
  SQL,
} from "drizzle-orm";
import { SortEnums } from "src/core/constants/enums/sort-enums";
import { withPagination } from "src/core/utils/db-utils";

@Injectable()
export class DeliveryRepository {
  constructor(
    @Inject(DRIZZLE_PROVIDER_KEY) private db: drizzleProvider.DrizzleDB,
  ) {}

  async create(data: CreateDeliverySchema) {
    const sequence = await this.db.execute(
      sql`SELECT nextval('delivery_seq') as seq`,
    );

    await this.db.transaction(async (tx) => {
      // create delivery
      const { articles, ...deliveryData } = data;
      const createdDelivery = await tx
        .insert(deliveries)
        .values({
          ...deliveryData,
          deliveryId: `${deliveryData.deliveryId}-${String(sequence)}`,
        })
        .returning();

      if (!createdDelivery[0]?.id) {
        tx.rollback();
      }

      // create articles
      for (const item of data.articles) {
        const { file, ...articleWithoutFile } = item;
        const createdArticle = await tx
          .insert(deliveryItems)
          .values({ ...articleWithoutFile, deliveryId: createdDelivery[0].id })
          .returning();

        if (!createdArticle[0]?.id) {
          tx.rollback();
        }

        // create file
        await tx.insert(files).values({
          ...file,
          deliveryItemId: createdArticle[0].id,
          userId: data.userId,
        });
      }
    });
  }

  async findById(
    userId: string,
    id: string,
  ): Promise<DeliveryWithArticles | null> {
    const result = (await this.db
      .select({
        ...getTableColumns(deliveries),
        articles: getTableColumns(deliveryItems),
      })
      .from(deliveries)
      .leftJoin(
        deliveryItems,
        eq(deliveryItems.deliveryId, deliveries.deliveryId),
      )
      .where(and(eq(deliveries.id, id), eq(deliveries.userId, userId)))
      .limit(1)) as DeliveryWithArticles[];

    return result[0] ?? null;
  }

  async findAll(
    userId: string,
    filter?: IGetAllDeliveriesQuery,
  ): Promise<{ count: number; deliveries: DeliveryWithArticles[] }> {
    const conditions: SQL[] = [eq(deliveries.userId, userId)];
    let orderBy: SQL = asc(deliveries.createdAt);

    if (filter?.status) {
      conditions.push(eq(deliveries.status, filter.status));
    }

    if (filter?.sort) {
      switch (filter.sort) {
        case SortEnums.TIME_SLOT:
          orderBy = desc(deliveries.timeSlotStart);
          break;

        case SortEnums.CREATION_DATE:
          orderBy = desc(deliveries.createdAt);
          break;
      }
    }

    const [{ total }] = await this.db
      .select({ total: count() })
      .from(deliveries)
      .where(and(...conditions));

    let query = this.db
      .select({
        ...getTableColumns(deliveries),
        articles: getTableColumns(deliveryItems),
      })
      .from(deliveries)
      .leftJoin(deliveryItems, eq(deliveryItems.deliveryId, deliveries.id))
      .where(and(...conditions))
      .$dynamic();

    if (filter?.limit || filter?.sort) {
      await withPagination(query, filter.page, filter.limit);
    }

    return {
      count: total,
      deliveries: (await query) as DeliveryWithArticles[],
    };
  }

  async update(deliveryId: string, data: UpdateDeliverySchema) {
    await this.db
      .update(deliveries)
      .set(data)
      .where(eq(deliveries.deliveryId, deliveryId));
  }

  async delete(deliveryId: string) {
    await this.db
      .delete(deliveries)
      .where(eq(deliveries.deliveryId, deliveryId));
  }
}

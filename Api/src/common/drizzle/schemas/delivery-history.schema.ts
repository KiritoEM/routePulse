import { pgEnum, pgTable, timestamp, uuid } from "drizzle-orm/pg-core";
import { deliveries, deliveryStatusEnum } from "./delivery.schema";

export const deliveryHistories = pgTable("delivery_histories", {
  id: uuid("id").defaultRandom().primaryKey(),
  deliveryId: uuid("delivery_id")
    .notNull()
    .references(() => deliveries.id, { onDelete: "cascade" }),
  fromStatus: deliveryStatusEnum("from_status"),
  toStatus: deliveryStatusEnum("to_status"),
  createdAt: timestamp("created_at", {
    withTimezone: true,
    mode: "date",
  })
    .defaultNow()
    .notNull(),
});

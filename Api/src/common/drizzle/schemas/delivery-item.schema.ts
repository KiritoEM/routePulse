import {
  pgTable,
  uuid,
  varchar,
  integer,
  doublePrecision,
} from "drizzle-orm/pg-core";
import { timestamps } from "./column-helper";
import { deliveries } from "./delivery.schema";

export const deliveryItems = pgTable("delivery_items", {
  id: uuid("id").defaultRandom().primaryKey(),
  name: varchar("name").notNull(),
  quantity: integer("quantity").notNull().default(1),
  price: doublePrecision("price"),
  deliveryId: uuid("delivery_id")
    .notNull()
    .references(() => deliveries.id, { onDelete: "cascade" }),
  ...timestamps,
});

// types
export type DeliveryItem = typeof deliveryItems.$inferSelect;

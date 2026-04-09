import { pgTable, uuid, timestamp, varchar } from "drizzle-orm/pg-core";
import { deliveries } from "./delivery.schema";

export const deliveryProof = pgTable("delivery_proof", {
  id: uuid("id").defaultRandom().primaryKey(),
  deliveryId: varchar("delivery_id")
    .notNull()
    .references(() => deliveries.deliveryId, { onDelete: "cascade" }),
  capturedAt: timestamp("created_at", {
    withTimezone: true,
    mode: "date",
  })
    .defaultNow()
    .notNull(),
});

// types
export type DeliveryProof = typeof deliveryProof.$inferSelect;

import {
  pgTable,
  uuid,
  varchar,
  text,
  date,
  time,
  doublePrecision,
  pgEnum,
  pgSequence
} from "drizzle-orm/pg-core";
import { timestamps } from "./column-helper";
import { users } from "./user.schema";
import { vehicles } from "./vehicle.schema";
import { clients } from "./client.schema";

export const deliveryStatusEnum = pgEnum("delivery_status", [
  "pending",
  "in_progress",
  "delivered",
  "cancelled",
  "reported",
]);

export const deliverySeq = pgSequence("delivery_seq", {
  startWith: 1,
  increment: 1,
});

export const deliveries = pgTable("deliveries", {
  id: uuid("id").defaultRandom().primaryKey(),
  deliveryId: varchar("delivery_id").notNull(),
  deliveryDate: date("delivery_date"),
  timeSlotStart: time("time_slot_start").notNull(),
  timeSlotEnd: time("time_slot_end").notNull(),
  address: text("address").notNull(),
  location: doublePrecision("delivery_location").array().notNull(),
  status: deliveryStatusEnum("status").default("pending"),
  notes: text("notes"),
  city: varchar("city"),
  totalKm: doublePrecision("total_km"),
  encryptedKey: text("encrypted_key").notNull(),
  deliveredAt: time("delivered_at"),
  userId: uuid("user_id")
    .notNull()
    .references(() => users.id, { onDelete: "cascade" }),
  vehicleId: uuid("vehicle_id")
    .notNull()
    .references(() => vehicles.id, { onDelete: "restrict" }),
  clientId: uuid("client_id")
    .notNull()
    .references(() => clients.id, { onDelete: "cascade" }),
  ...timestamps,
});

// types
export type Delivery = typeof deliveries.$inferSelect;

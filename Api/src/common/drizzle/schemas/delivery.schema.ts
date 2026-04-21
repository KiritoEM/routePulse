import {
  pgTable,
  uuid,
  varchar,
  text,
  date,
  time,
  integer,
  doublePrecision,
  pgEnum,
  pgSequence,
} from "drizzle-orm/pg-core";
import { timestamps } from "./column-helper";
import { users } from "./user.schema";
import { vehicles } from "./vehicle.schema";
import { clients } from "./client.schema";

export const deliverySeq = pgSequence("delivery_seq", {
  startWith: 1,
  increment: 1,
});

export const deliveryStatusEnum = pgEnum("delivery_status", [
  "pending",
  "in_progress",
  "delivered",
  "cancelled",
  "reported",
]);

export const deliveries = pgTable("deliveries", {
  deliveryId: varchar("delivery_id").primaryKey(),
  deliveryDate: date("delivery_date"),
  timeSlotStart: time("time_slot_start").notNull(),
  timeSlotEnd: time("time_slot_end").notNull(),
  address: text("address").notNull(),
  location: integer("location").array().notNull(),
  status: deliveryStatusEnum("status").default("pending"),
  notes: text("notes"),
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
    .references(() => clients.id, { onDelete: "restrict" }),
  ...timestamps,
});

// types
export type Delivery = typeof deliveries.$inferSelect;

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

export const deliveries = pgTable("deliveries", {
  deliveryId: varchar("delivery_id").primaryKey(),
  deliveryDate: date("delivery_date"),
  timeSlot: varchar("time_slot"),
  address: text("address"),
  location: integer("location").array(),
  status: deliveryStatusEnum("status").default("pending"),
  notes: text("notes"),
  totalKm: doublePrecision("total_km"),
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

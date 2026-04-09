import { pgTable, uuid, varchar, pgEnum, boolean } from "drizzle-orm/pg-core";
import { users } from "./user.schema";
import { timestamps } from "./column-helper";

export const vehicleTypeEnum = pgEnum("vehicle_type", [
  "moto",
  "bicycle",
  "car",
]);

export const vehicles = pgTable("vehicles", {
  id: uuid("id").defaultRandom().primaryKey(),
  name: varchar("name").notNull(),
  type: vehicleTypeEnum("type").default("moto"),
  plateNumber: varchar("plate_number"),
  isActive: boolean("is_active").default(true),
  userId: uuid("user_id")
    .notNull()
    .references(() => users.id, { onDelete: "cascade" }),
  ...timestamps,
});

// types
export type Vehicle = typeof vehicles.$inferSelect;

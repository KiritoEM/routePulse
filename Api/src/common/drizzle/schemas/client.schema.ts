import {
  pgTable,
  uuid,
  varchar,
  text,
  integer,
  doublePrecision,
} from "drizzle-orm/pg-core";
import { softDelete, timestamps } from "./column-helper";
import { users } from "./user.schema";

export const clients = pgTable("clients", {
  id: uuid("id").defaultRandom().primaryKey(),
  name: varchar("name").notNull(),
  phoneNumber: varchar("phone_number").notNull(),
  address: text("address").notNull(),
  location: doublePrecision("client_location").array().notNull(),
  city: varchar("city"),
  encryptedKey: text("encrypted_key"),
  userId: uuid("user_id")
    .notNull()
    .references(() => users.id, { onDelete: "cascade" }),
  ...timestamps,
  ...softDelete,
});

// types
export type Client = typeof clients.$inferSelect;

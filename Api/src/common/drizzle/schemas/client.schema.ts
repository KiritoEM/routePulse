import {
  pgTable,
  uuid,
  varchar,
  text,
  json,
} from "drizzle-orm/pg-core";
import { timestamps } from "./column-helper";
import { users } from "./user.schema";

export const clients = pgTable("clients", {
  id: uuid("id").defaultRandom().primaryKey(),
  name: varchar("name").notNull(),
  phoneNumber: varchar("phone_number").notNull(),
  address: text("address").notNull(),
  location: json(),
  userId: uuid("user_id")
    .notNull()
    .references(() => users.id, { onDelete: "cascade" }),
  ...timestamps,
});


// types
export type Client = typeof clients.$inferSelect;

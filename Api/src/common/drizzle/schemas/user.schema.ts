import { pgTable, uuid, varchar, text, boolean } from "drizzle-orm/pg-core";
import { timestamps, softDelete } from "./column-helper";

export const users = pgTable("users", {
  id: uuid("id").defaultRandom().primaryKey(),
  fullName: varchar("full_name").notNull(),
  password: varchar("password").notNull(),
  email: text("email").notNull(),
  refreshToken: text("refresh_token"),
  biometricEnabled: boolean("biometric_enabled").default(false),
  ...softDelete,
  ...timestamps,
});

// types
export type User = typeof users.$inferSelect;

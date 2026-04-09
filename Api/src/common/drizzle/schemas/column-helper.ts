import { boolean, timestamp } from "drizzle-orm/pg-core";

export const timestamps = {
  createdAt: timestamp("created_at", {
    withTimezone: true,
    mode: "date",
  })
    .defaultNow()
    .notNull(),

  updatedAt: timestamp("updated_at", {
    withTimezone: true,
    mode: "date",
  })
    .defaultNow()
    .notNull()
    .$onUpdate(() => new Date()),
};

export const softDelete = {
  isDeleted: boolean("is_deleted").default(false),
  deleted_at: timestamp("deleted_at", {
    withTimezone: true,
    mode: "date",
  })
    .defaultNow()
    .notNull(),
};

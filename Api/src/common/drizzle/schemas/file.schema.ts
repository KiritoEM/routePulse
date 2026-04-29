import { bigint } from "drizzle-orm/pg-core";
import { pgTable, text, uuid, varchar } from "drizzle-orm/pg-core";
import { timestamps } from "./column-helper";
import { users } from "./user.schema";
import { deliveryProof } from "./delivery-proof.schema";
import { deliveryItems } from "./delivery-item.schema";

export const files = pgTable("files", {
  id: uuid("id").defaultRandom().primaryKey(),
  fileName: text("file_name"),
  path: varchar("path").notNull(),
  mimeType: varchar("mime_type"),
  size: bigint("size", { mode: "number" }),
  userId: uuid("user_id")
    .notNull()
    .references(() => users.id, { onDelete: "cascade" }),
  deliveryItemId: uuid("delivery_item_id")
    .references(() => deliveryItems.id, { onDelete: "cascade" }),
  signatureForProofId: uuid("signature_for_proof_id").references(
    () => deliveryProof.id,
    { onDelete: "set null" },
  ),
  pictureForProofId: uuid("picture_for_proof_id").references(
    () => deliveryProof.id,
    { onDelete: "set null" },
  ),
  ...timestamps,
});

// types
export type File = typeof files.$inferSelect;

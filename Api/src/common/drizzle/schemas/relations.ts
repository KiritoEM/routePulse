import { relations } from "drizzle-orm";
import { users } from "./user.schema";
import { clients } from "./client.schema";
import { vehicles } from "./vehicle.schema";
import { deliveries } from "./delivery.schema";
import { deliveryItems } from "./delivery-item.schema";
import { deliveryProof } from "./delivery-proof.schema";
import { files } from "./file.schema";

// Users relations
export const usersRelations = relations(users, ({ one, many }) => ({
  clients: many(clients),
  vehicles: many(vehicles),
  deliveries: many(deliveries),
  profilePicture: one(files),
}));

// Clients relations
export const clientsRelations = relations(clients, ({ one, many }) => ({
  user: one(users, {
    fields: [clients.userId],
    references: [users.id],
  }),
  deliveries: many(deliveries),
}));

// Vehicles relations
export const vehiclesRelations = relations(vehicles, ({ one, many }) => ({
  user: one(users, {
    fields: [vehicles.userId],
    references: [users.id],
  }),
  deliveries: many(deliveries),
}));

// Deliveries relations
export const deliveriesRelations = relations(deliveries, ({ one, many }) => ({
  user: one(users, {
    fields: [deliveries.userId],
    references: [users.id],
  }),
  vehicle: one(vehicles, {
    fields: [deliveries.vehicleId],
    references: [vehicles.id],
  }),
  client: one(clients, {
    fields: [deliveries.clientId],
    references: [clients.id],
  }),
  articles: many(deliveryItems),
  proof: one(deliveryProof),
}));

// Delivery Items relations
export const deliveryItemsRelations = relations(deliveryItems, ({ one }) => ({
  delivery: one(deliveries, {
    fields: [deliveryItems.deliveryId],
    references: [deliveries.id],
  }),
  image: one(files),
}));

// Delivery Proof relations
export const deliveryProofRelations = relations(
  deliveryProof,
  ({ one, many }) => ({
    delivery: one(deliveries, {
      fields: [deliveryProof.deliveryId],
      references: [deliveries.deliveryId],
    }),
    signatureFile: many(files, {
      relationName: "signature",
    }),
    pictureFiles: many(files, {
      relationName: "pictures",
    }),
  }),
);

// Files relations
export const filesRelations = relations(files, ({ one }) => ({
  user: one(users, {
    fields: [files.userId],
    references: [users.id],
  }),
  deliveryItem: one(deliveryItems, {
    fields: [files.deliveryItemId],
    references: [deliveryItems.id],
  }),
  signatureForProof: one(deliveryProof, {
    fields: [files.signatureForProofId],
    references: [deliveryProof.id],
    relationName: "signature",
  }),
  pictureForProof: one(deliveryProof, {
    fields: [files.pictureForProofId],
    references: [deliveryProof.id],
    relationName: "pictures",
  }),
}));

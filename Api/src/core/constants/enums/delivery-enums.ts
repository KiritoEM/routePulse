export const DeliveryStatus = {
  PENDING: "pending",
  IN_PROGRESS: "in_progress",
  DELIVERED: "delivered",
  CANCELLED: "cancelled",
  REPORTED: "reported",
} as const;

export type DeliveryStatus = (typeof DeliveryStatus)[keyof typeof DeliveryStatus];

export enum DeliveriesCountType {
   TODO,
   FINISHED
}

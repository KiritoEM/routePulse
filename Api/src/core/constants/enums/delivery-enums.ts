export const DeliveryStatus = {
  PENDING: "pending",
  IN_PROGRESS: "in_progress",
  DELIVERED: "delivered",
  CANCELLED: "cancelled",
  REPORTED: "reported",
} as const;

export type DeliveryStatus = (typeof DeliveryStatus)[keyof typeof DeliveryStatus];

export const DeliveryPeriod = {
  ALL: "all",
  TODAY: "today",
} as const;

export type DeliveryPeriod = (typeof DeliveryPeriod)[keyof typeof DeliveryPeriod];

export enum DeliveriesCountType {
  TODO = "todo",
  FINISHED = "finished",
}

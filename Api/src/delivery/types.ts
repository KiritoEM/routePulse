import { Delivery, DeliveryItem } from "src/common/drizzle/schemas";
import { DeliveryStatus } from "src/core/constants/enums/delivery-enums";
import { IBaseApiReturn, IFilter, IPagination } from "src/core/types";

export type CreateDeliverySchema = Pick<
  Delivery,
  | "deliveryId"
  | "userId"
  | "clientId"
  | "address"
  | "location"
  | "deliveryDate"
  | "vehicleId"
  | "timeSlotStart"
  | "timeSlotEnd"
  | "notes"
  | "encryptedKey"
> & {
  articles: Omit<DeliveryItem, "id" | "createdAt" | "updatedAt">[];
};

export type UpdateDeliverySchema = Partial<CreateDeliverySchema> & {
  status?: DeliveryStatus;
};

export type DeliveryPublic = Omit<Delivery, "encryptedKey">;

export type DeliveryWithArticles = Delivery & {
  articles: DeliveryItem;
};

export interface IGetAllDeliveriesQuery extends IFilter, IPagination {
  status?: DeliveryStatus;
}

export interface IGetAllDeliveriesResponse extends IBaseApiReturn {
  total: int;
  data: Omit<DeliveryWithArticles, "encryptedKey">[];
}

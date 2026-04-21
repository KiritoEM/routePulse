import { Delivery, DeliveryItem, File } from "src/common/drizzle/schemas";
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
  articles: ArticleWithFile[];
};

export type ArticleWithFile = Omit<
  DeliveryItem,
  "id" | "createdAt" | "updatedAt" | "deliveryId"
> & {
  file: Pick<File, "path" | "size" | "fileName" | "mimeType">;
};

export type CreateDeliveryServiceSchema = Pick<
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
  articles: (Omit<
    DeliveryItem,
    "id" | "createdAt" | "updatedAt" | "deliveryId"
  > & {
    file: {
      file: string;
      originalName: string;
      mimeType: string;
      size: number;
    };
  })[];
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
  total: number;
  data: DeliveryPublic[];
}

export interface IGetDeliveryResponse extends IBaseApiReturn {
  data: DeliveryPublic;
}

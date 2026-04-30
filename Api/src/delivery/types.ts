import {
  Client,
  Delivery,
  DeliveryItem,
  File,
} from "src/common/drizzle/schemas";
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
  | "city"
> & {
  articles: ArticleWithFile[];
};

export type ValidateDeliveryServiceSchema = Pick<
  Delivery,
  "totalKm" | "deliveredAt"
> & {
  file?: {
    file: string;
    originalName: string;
    mimeType: string;
    size: number;
  } | null;
};

export type ArticleWithFile = Omit<
  DeliveryItem,
  "id" | "createdAt" | "updatedAt" | "deliveryId"
> & {
  file?: FileFromRequest;
};

export type FileFromRequest = Pick<
  File,
  "path" | "size" | "fileName" | "mimeType"
> | null;

export type ValidateDeliverySchema = {
  file: FileFromRequest;
} & Pick<Delivery, "totalKm" | "deliveredAt">;

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
  | "city"
> & {
  articles: (Omit<
    DeliveryItem,
    "id" | "createdAt" | "updatedAt" | "deliveryId"
  > & {
    file?: {
      file: string;
      originalName: string;
      mimeType: string;
      size: number;
    };
  })[];
  checkIsExist?: boolean;
  existingId?: string;
  existingDeliveryId?: string;
};

export type UpdateDeliveryWithStatus = {
  fromStatus?: DeliveryStatus;
  toStatus?: DeliveryStatus;
  date?: string;
  cancelReason?: string;
};

export type UpdateDeliverySchema = Partial<CreateDeliverySchema> & {
  status?: DeliveryStatus;
};

export type ArticleWithImageResult = DeliveryItem & { image?: File | null };

export type DeliveryResult = Delivery & {
  articles: ArticleWithImageResult[];
  client: Omit<Client, "encryptedKey" | "address" | "location">;
};

export type DeliveryPublic = Omit<DeliveryResult, "encryptedKey">;

export interface IGetAllDeliveriesQuery extends IFilter, IPagination {
  status?: DeliveryStatus;
}

export interface ICreateDeliveryResponse extends IBaseApiReturn {
  data?: Pick<Delivery, "id" | "deliveryId"> | null;
}

export interface IGetAllDeliveriesResponse extends IBaseApiReturn {
  total: number;
  data: DeliveryPublic[];
}

export interface IGetTodayDeliveriesResponse extends IBaseApiReturn {
  data: DeliveryPublic[];
}

export interface IGetDeliveriesCountResponse extends IBaseApiReturn {
  data: number;
}

export interface IGetDeliveryResponse extends IBaseApiReturn {
  data: DeliveryPublic;
}

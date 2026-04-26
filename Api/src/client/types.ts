import { Client } from "src/common/drizzle/schemas";
import { IBaseApiReturn } from "src/core/types";

export type CreateClientSchema = Pick<
  Client,
  "name" | "phoneNumber" | "location" | "address" | "userId" | "encryptedKey"
> & {
  city?: string | null;
};

export type UpdateClientSchema = Partial<CreateClientSchema>;

export type ClientPublic = Omit<Client, "encryptedKey">;

export interface ISearchClientResponse extends IBaseApiReturn {
  data: ClientPublic[];
}

export interface ICreateClientResponse extends IBaseApiReturn {
  data: ClientPublic | null;
}

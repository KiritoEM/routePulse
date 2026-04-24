import { Client } from "src/common/drizzle/schemas";
import { IBaseApiReturn } from "src/core/types";

export type CreateClientSchema = Pick<
  Client,
  "name" | "phoneNumber" | "location" | "address" | "userId" | "encryptedKey"
>;

export type ClientPublic = Omit<Client, "encryptedKey">;

export interface ISearchClientResponse extends IBaseApiReturn {
  data: ClientPublic[];
}

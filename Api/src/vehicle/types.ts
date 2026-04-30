import { Vehicle } from "src/common/drizzle/schemas";
import { IBaseApiReturn } from "src/core/types";

export type CreateVehicleSchema = Pick<
  Vehicle,
  "plateNumber" | "name" | "type" | "userId"
>;

export type UpdateVehicleSchema = Partial<CreateVehicleSchema>;

export interface ICreateVehicleResponse extends IBaseApiReturn {
  data?: Vehicle | null;
}

export interface IUpdateVehicleResponse extends IBaseApiReturn {
  data?: Vehicle | null;
}

export interface IgetAllVehiclesResponse extends IBaseApiReturn {
  data: Vehicle[];
}

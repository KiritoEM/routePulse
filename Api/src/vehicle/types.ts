import { Vehicle } from "src/common/drizzle/schemas";
import { IBaseApiReturn } from "src/core/types";

export type CreateVehicleSchema = Pick<
  Vehicle,
  "plateNumber" | "name" | "type" | "userId"
>;

export interface ICreateVehicleResponse extends IBaseApiReturn {
  data?: Pick<Vehicle, "id"> | null;
}

export interface IgetAllVehiclesResponse extends IBaseApiReturn {
  data: Vehicle[];
}

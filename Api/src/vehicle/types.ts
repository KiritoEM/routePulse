import { Vehicle } from "src/common/drizzle/schemas";
import { IBaseApiReturn } from "src/core/types";

export type CreateVehicleSchema = Pick<
  Vehicle,
  "plateNumber" | "name" | "type" | "userId"
>;

export interface IgetAllVehiclesResponse extends IBaseApiReturn {
	data: Vehicle[];
}

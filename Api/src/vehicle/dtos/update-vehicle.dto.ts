import { PartialType, PickType } from "@nestjs/mapped-types";
import { VehicleEntity } from "../entities/vehicle.entity";

export class UpdateVehicleDTO extends PartialType(
  PickType(VehicleEntity, ["plateNumber", "name", "type"]),
) {}

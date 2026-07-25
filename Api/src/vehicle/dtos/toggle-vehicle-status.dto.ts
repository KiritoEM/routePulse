import { PickType } from "@nestjs/mapped-types";
import { VehicleEntity } from "../entities/vehicle.entity";

export class ToggleVehicleStatusDTO extends PickType(VehicleEntity, [
  "isActive",
]) {}

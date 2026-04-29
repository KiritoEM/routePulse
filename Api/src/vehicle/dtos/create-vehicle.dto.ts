import { PickType } from "@nestjs/mapped-types";
import { IsString, IsOptional, IsNumber, MinLength } from "class-validator";
import { VehicleEntity } from "../entities/vehicle.entity";

export class CreateVehicleDTO extends PickType(VehicleEntity, [
  "plateNumber",
  "name",
  "type",
]) {}

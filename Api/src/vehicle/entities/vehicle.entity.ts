import { IsBoolean, IsEnum, IsNotEmpty, IsOptional, IsString, IsUUID } from "class-validator";
import { vehicleTypeEnum } from "src/common/drizzle/schemas/vehicle.schema";

export class VehicleEntity {
  @IsUUID()
  @IsNotEmpty()
  id!: string;

  @IsString()
  @IsNotEmpty()
  name!: string;

  @IsEnum(vehicleTypeEnum.enumValues)
  type!: "moto" | "bicycle" | "car";

  @IsString()
  @IsOptional()
  plateNumber?: string | null;

  @IsBoolean()
  isActive!: boolean;

  @IsUUID()
  @IsNotEmpty()
  userId!: string;

  @IsNotEmpty()
  createdAt!: Date;

  @IsNotEmpty()
  updatedAt!: Date;
}

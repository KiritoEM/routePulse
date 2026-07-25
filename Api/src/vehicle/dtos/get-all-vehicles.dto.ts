import { Transform } from "class-transformer";
import { IsBoolean, IsOptional } from "class-validator";

export class GetAllVehiclesQueryDTO {
  @Transform(({ value }) => value === true || value === "true")
  @IsBoolean()
  @IsOptional()
  isActive?: boolean;
}

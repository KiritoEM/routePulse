import { PickType } from "@nestjs/mapped-types";
import {
  IsDateString,
  IsNotEmpty,
  IsOptional,
  IsString,
  ValidateNested,
} from "class-validator";
import { DeliveryEntity } from "../entities/delivery.entity";
import { CreateFileDTO } from "../entities/delivery-item.entity";
import { Type } from "class-transformer";

export class ReportDeliveryDTO {
  @IsDateString()
  @IsNotEmpty()
  newDate: string;
}

export class CancelDeliveryDTO {
  @IsString()
  @IsNotEmpty()
  reason: string;
}

export class ValidateDeliveryDTO extends PickType(DeliveryEntity, [
  "totalKm",
  "deliveredAt",
]) {
  @ValidateNested()
  @Type(() => CreateFileDTO)
  @IsOptional()
  file: CreateFileDTO;
}

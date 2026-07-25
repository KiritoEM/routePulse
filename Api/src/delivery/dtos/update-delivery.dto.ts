import { PickType } from "@nestjs/mapped-types";
import {
  IsDateString,
  IsNotEmpty,
  IsOptional,
  IsString,
  Matches,
  ValidateNested,
} from "class-validator";
import { DeliveryEntity } from "../entities/delivery.entity";
import { CreateFileDTO } from "../entities/delivery-item.entity";
import { Type } from "class-transformer";

// HH:mm or HH:mm:ss
const TIME_SLOT_REGEX = /^([01]\d|2[0-3]):[0-5]\d(:[0-5]\d)?$/;

export class ReportDeliveryDTO {
  @IsDateString()
  @IsNotEmpty()
  newDate: string;

  @Matches(TIME_SLOT_REGEX, { message: "Créneau horaire invalide" })
  @IsOptional()
  timeSlotStart?: string;

  @Matches(TIME_SLOT_REGEX, { message: "Créneau horaire invalide" })
  @IsOptional()
  timeSlotEnd?: string;
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

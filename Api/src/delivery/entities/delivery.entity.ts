import {
  IsString,
  IsNotEmpty,
  IsOptional,
  IsArray,
  IsNumber,
  IsEnum,
  IsUUID,
  IsDateString,
  IsMilitaryTime,
} from "class-validator";
import { DeliveryStatus } from "src/core/constants/enums/delivery-enums";

export class DeliveryEntity {
  @IsString()
  @IsNotEmpty()
  deliveryId!: string;

  @IsDateString()
  @IsOptional()
  deliveryDate!: string | null;

  @IsString()
  @IsNotEmpty()
  timeSlotStart: string;

  @IsString()
  @IsNotEmpty()
  timeSlotEnd: string;

  @IsString()
  @IsNotEmpty()
  address!: string;

  @IsArray()
  @IsNumber({}, { each: true })
  location!: number[];

  @IsString()
  @IsNotEmpty()
  city!: string;

  @IsEnum(DeliveryStatus)
  @IsOptional()
  status!: DeliveryStatus | null;

  @IsString()
  @IsOptional()
  notes!: string | null;

  @IsNumber()
  @IsOptional()
  totalKm!: number | null;

  @IsString()
  @IsOptional()
  deliveredAt!: string | null;

  @IsUUID()
  @IsNotEmpty()
  userId!: string;

  @IsUUID()
  @IsNotEmpty()
  vehicleId!: string;

  @IsUUID()
  @IsNotEmpty()
  clientId!: string;
}

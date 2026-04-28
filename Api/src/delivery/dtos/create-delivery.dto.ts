import { OmitType } from "@nestjs/mapped-types";
import { IsArray, IsBoolean, IsNotEmpty, IsOptional, IsString, ValidateNested } from "class-validator";
import { Type } from "class-transformer";
import { DeliveryEntity } from "../entities/delivery.entity";
import { DeliveryItemEntity } from "../entities/delivery-item.entity";

export class CreateDeliveryDTO extends OmitType(DeliveryEntity, [
  "deliveredAt",
  "deliveryId",
  "status",
  "userId",
]) {
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => DeliveryItemEntity)
  @IsNotEmpty()
  articles!: DeliveryItemEntity[];

  @IsBoolean()
  @IsOptional()
  checkIsExist?: boolean;

  @IsString()
  @IsOptional()
  existingId?: string;

  @IsString()
  @IsOptional()
  existingDeliveryId?: string;

}

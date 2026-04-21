import {
 IsString,
  IsNotEmpty,
  IsOptional,
  IsNumber,
  IsUUID,
  IsInt,
  Min,
} from "class-validator";

export class DeliveryItemEntity {
  @IsUUID()
  @IsNotEmpty()
  id!: string;

  @IsString()
  @IsNotEmpty()
  name!: string;

  @IsInt()
  @Min(1)
  quantity!: number;

  @IsNumber()
  @IsOptional()
  price!: number | null;

  @IsString()
  @IsNotEmpty()
  deliveryId!: string;
}

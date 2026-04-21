import { Type } from "class-transformer";
import {
  IsString,
  IsNotEmpty,
  IsOptional,
  IsNumber,
  IsUUID,
  IsInt,
  Min,
  ValidateNested,
} from "class-validator";

class CreateFileDTO {
  @IsString()
  @IsNotEmpty()
  file!: string;

  @IsString()
  @IsNotEmpty()
  originalName!: string;

  @IsString()
  @IsNotEmpty()
  mimeType!: string;

  @IsInt()
  @Min(1)
  size!: number;
}

export class DeliveryItemEntity {
  @ValidateNested()
  @Type(() => CreateFileDTO)
  @IsNotEmpty()
  file!: CreateFileDTO;

  @IsString()
  @IsNotEmpty()
  name!: string;

  @IsInt()
  @Min(1)
  quantity!: number;

  @IsNumber()
  @IsOptional()
  price!: number | null; 
}

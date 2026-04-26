import {
  IsString,
  IsNotEmpty,
  IsPhoneNumber,
  IsUUID,
  IsArray,
  IsNumber,
  IsOptional,
} from "class-validator";

export class ClientEntity {
  @IsUUID()
  @IsNotEmpty()
  id!: string;

  @IsString()
  @IsNotEmpty()
  name!: string;

  @IsString()
  @IsOptional()
  city?: string | null;

  @IsString()
  @IsNotEmpty()
  phoneNumber!: string;

  @IsString()
  address: string;

  @IsArray()
  @IsNumber({}, { each: true })
  location!: number[];
}

import {
  IsString,
  IsNotEmpty,
  IsPhoneNumber,
  IsUUID,
  IsArray,
  IsNumber,
} from "class-validator";

export class ClientEntity {
  @IsUUID()
  @IsNotEmpty()
  id!: string;

  @IsString()
  @IsNotEmpty()
  name!: string; 

  @IsString()
  @IsNotEmpty()
  phoneNumber!: string;

  @IsString()
  address: string

  @IsArray()
  @IsNumber({}, { each: true })
  location!: number[];
}

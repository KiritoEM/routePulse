// dto/create-client.dto.ts
import { PickType } from "@nestjs/mapped-types";
import {
  IsArray,
  IsNotEmpty,
  IsString,
  ArrayMinSize,
  IsNumber,
  IsBoolean,
} from "class-validator";
import { ClientEntity } from "../entities/client.entity";

export class CreateClientDto extends PickType(ClientEntity, [
  "name",
  "location",
  "address",
  "phoneNumber",
]) {
  @IsBoolean()
  checkName!: boolean;
}

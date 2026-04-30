import { PickType } from "@nestjs/mapped-types";
import { IsBoolean } from "class-validator";
import { ClientEntity } from "../entities/client.entity";

export class CreateClientDto extends PickType(ClientEntity, [
  "name",
  "location",
  "address",
  "phoneNumber",
  "city",
]) {
  @IsBoolean()
  checkName!: boolean;
}

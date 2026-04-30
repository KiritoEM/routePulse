import { PartialType, PickType } from "@nestjs/mapped-types";
import { IsBoolean } from "class-validator";
import { ClientEntity } from "../entities/client.entity";

export class UpdateClientDto extends PartialType(
  PickType(ClientEntity, [
    "name",
    "location",
    "address",
    "phoneNumber",
    "city",
  ]),
) {}

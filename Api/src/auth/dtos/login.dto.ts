import { PickType } from "@nestjs/mapped-types";
import { IsEmail, IsNotEmpty, IsString } from "class-validator";
import { UserEntity } from "src/user/entities/user.entity";

export class LoginDTO extends PickType(UserEntity, ["email", "password"]) {}

export class BiometricLoginDTO extends PickType(UserEntity, ["id"]) {}

import { PickType } from "@nestjs/mapped-types";
import { IsBoolean, IsEmail, IsNotEmpty, IsString } from "class-validator";
import { UserEntity } from "src/user/entities/user.entity";

export class SendRegisterOtpDTO extends PickType(UserEntity, [
  "email",
  "fullName",
]) {}

export class ValidRegisterOtpDTO {
  @IsNotEmpty()
  @IsString()
  code!: string;

  @IsNotEmpty()
  @IsString()
  verificationToken!: string;
}

export class RegisterCreatePasswordDTO extends PickType(UserEntity, [
  "password",
  "biometricEnabled",
]) {
  @IsNotEmpty()
  @IsString()
  creationToken!: string;
}

export class ResendRegisterOtpDTO {
  @IsNotEmpty()
  @IsString()
  verificationToken!: string;

}

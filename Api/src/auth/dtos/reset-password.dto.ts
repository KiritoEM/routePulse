
import { PickType } from "@nestjs/mapped-types";
import { IsEmail, IsNotEmpty, IsString } from "class-validator";
import { UserEntity } from "src/user/entities/user.entity";

export class SendResetPasswordOtpDTO extends PickType(UserEntity, ["email"]) {}

export class ValidResetPasswordOtpDTO {
  @IsNotEmpty()
  @IsString()
  code!: string;

  @IsNotEmpty()
  @IsString()
  verificationToken!: string;
}

export class CreateNewPasswordOtpDTO {
  @IsNotEmpty()
  @IsString()
  resetToken!: string;

  @IsNotEmpty()
  @IsString()
  password!: string;
}

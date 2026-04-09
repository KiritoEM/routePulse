import { IsBoolean, IsEmail, IsNotEmpty, IsString } from "class-validator";

export class UserEntity {
  @IsEmail()
  @IsNotEmpty()
  email!: string;

  @IsNotEmpty()
  @IsString()
  fullName!: string;

  @IsNotEmpty()
  @IsString()
  password!: string;

  @IsBoolean()
  biometricEnabled!: boolean;
}

import {
  Body,
  Controller,
  HttpCode,
  HttpStatus,
  Patch,
  Post,
} from "@nestjs/common";
import { Throttle } from "@nestjs/throttler";
import { AuthService } from "./auth.service";
import {
  RegisterCreatePasswordDTO,
  ResendRegisterOtpDTO,
  SendRegisterOtpDTO,
  ValidRegisterOtpDTO,
} from "./dtos/register.dto";
import {
  ILoginResponse,
  IRegisterCreatePasswordResponse,
  ISendRegisterOtpResponse,
  ISendResetPasswordOtpResponse,
  IVerify2FAResponse,
} from "./types";
import { IBaseApiReturn } from "src/core/types";
import {
  CreateNewPasswordOtpDTO,
  SendResetPasswordOtpDTO,
  ValidResetPasswordOtpDTO,
} from "./dtos/reset-password.dto";
import { BiometricLoginDTO, LoginDTO } from "./dtos/login.dto";

@Controller("auth")
@Throttle({ default: { limit: 60, ttl: 60000 } })
export class AuthController {
  constructor(private authService: AuthService) {}

  /** Send an OTP code by email to register a new user */
  @Post("register/send-otp")
  @HttpCode(HttpStatus.OK)
  async sendRegisterOtp(
    @Body() sendRegisterOtpDto: SendRegisterOtpDTO,
  ): Promise<ISendRegisterOtpResponse> {
    const { verificationToken } =
      await this.authService.sendRegisterOtp(sendRegisterOtpDto);

    return {
      statusCode: HttpStatus.OK,
      message: "un code de vérification a été envoyé à votre adresse e-mail",
      verificationToken,
    };
  }

  /** Validate the OTP code to verify the user's email */
  @Post("register/validate-otp")
  @HttpCode(HttpStatus.OK)
  async validRegisterOtp(
    @Body() validRegisterOtpDto: ValidRegisterOtpDTO,
  ): Promise<IVerify2FAResponse> {
    const { creationToken } = await this.authService.validRegisterOtp(
      validRegisterOtpDto.code,
      validRegisterOtpDto.verificationToken,
    );
    return {
      statusCode: HttpStatus.OK,
      message: "Votre adresse e-mail a été vérifiée avec succès",
      creationToken,
    };
  }

  /** Resend signup OTP code */
  @Post("register/resend-otp")
  @HttpCode(HttpStatus.OK)
  async resendSignupOTP(
    @Body() signupResendOtpDto: ResendRegisterOtpDTO,
  ): Promise<ISendRegisterOtpResponse> {
    const { verificationToken } = await this.authService.resendSignupOTP(
      signupResendOtpDto.verificationToken,
    );

    return {
      statusCode: HttpStatus.OK,
      message: "Code OTP réenvoyé avec succés",
      verificationToken,
    };
  }

  /** Create the user's password and finalize account registration */
  @Post("register/create-password")
  @HttpCode(HttpStatus.OK)
  async createPassword(
    @Body() createPasswordDto: RegisterCreatePasswordDTO,
  ): Promise<IRegisterCreatePasswordResponse> {
    const tokens = await this.authService.createNewUserAndGenerateTokens(
      createPasswordDto.creationToken,
      createPasswordDto.password,
      createPasswordDto.biometricEnabled,
    );

    return {
      statusCode: HttpStatus.OK,
      message: "Votre compte a été créé avec succès !!!",
      data: {
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
        user: tokens.user,
      },
    };
  }

  /** Authenticate user and return access & refresh tokens */
  @Post("login")
  @HttpCode(HttpStatus.OK)
  async login(@Body() loginDTO: LoginDTO): Promise<ILoginResponse> {
    const tokens = await this.authService.login({
      email: loginDTO.email,
      password: loginDTO.password,
    });

    return {
      statusCode: HttpStatus.OK,
      message: "Connexion réussie",
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    };
  }

  /** Authenticate user with biometric and return access & refresh tokens */
  @Post("biometric-login")
  @HttpCode(HttpStatus.OK)
  async loginWithBiometric(
    @Body() loginDTO: BiometricLoginDTO,
  ): Promise<ILoginResponse> {
    const tokens = await this.authService.loginWithBiometric(loginDTO.id);

    return {
      statusCode: HttpStatus.OK,
      message: "Connexion avec biometrie réussie",
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    };
  }

  /** Send an OTP code by email to reset the user's password */
  @Post("forgot-password/send-otp")
  @HttpCode(HttpStatus.OK)
  async sendResetPasswordOtp(
    @Body() sendResetPasswordOtpDto: SendResetPasswordOtpDTO,
  ): Promise<ISendRegisterOtpResponse> {
    const { verificationToken } = await this.authService.sendResetPasswordOtp(
      sendResetPasswordOtpDto.email,
    );

    return {
      statusCode: HttpStatus.OK,
      message:
        "Un code de réinitialisation a été envoyé à votre adresse e-mail.",
      verificationToken,
    };
  }

  /** Validate the OTP code to authorize a password reset */
  @Post("forgot-password/validate-otp")
  @HttpCode(HttpStatus.OK)
  async validResetPasswordOtp(
    @Body() validResetPasswordOtpDto: ValidResetPasswordOtpDTO,
  ): Promise<ISendResetPasswordOtpResponse> {
    const { resetToken } = await this.authService.validateResetPasswordOtp(
      validResetPasswordOtpDto.code,
      validResetPasswordOtpDto.verificationToken,
    );

    return {
      statusCode: HttpStatus.OK,
      message:
        "Code validé avec succès. Vous pouvez maintenant créer un nouveau mot de passe.",
      resetToken,
    };
  }

  /** Reset the user's password */
  @Patch("reset-password")
  @HttpCode(HttpStatus.OK)
  async createNewPassword(
    @Body() validResetPasswordOtpDto: CreateNewPasswordOtpDTO,
  ): Promise<IBaseApiReturn> {
    await this.authService.createNewPassword(
      validResetPasswordOtpDto.resetToken,
      validResetPasswordOtpDto.password,
    );

    return {
      statusCode: HttpStatus.OK,
      message:
        "Votre mot de passe a été mis à jour avec succès. Vous pouvez maintenant vous connecter.",
    };
  }
}

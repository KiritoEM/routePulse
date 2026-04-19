/* eslint-disable @typescript-eslint/no-unused-vars */
import {
  BadRequestException,
  ConflictException,
  HttpException,
  HttpStatus,
  Injectable,
  InternalServerErrorException,
  Logger,
  NotFoundException,
  UnauthorizedException,
} from "@nestjs/common";
import {
  CachedResetPasswordPayload,
  LoginSchema,
  RegisterSchema,
  TokensType,
  UserPublic,
} from "./types";
import { UserRepository } from "src/user/user.repository";
import { OtpService } from "src/common/otp/otp.service";
import { comparePassword, hashPassword } from "src/core/utils/hashing-utils";
import {
  aes256GcmEncrypt,
  formatEncryptedData,
  generateRandomString,
} from "src/core/utils/crypto-utils";
import { SendOtpService } from "./send-otp.service";
import { AuthRetryService } from "./auth-retry.service";
import {
  JWT_ACCESS_TOKEN_DURATION,
  JWT_REFRESH_TOKEN_DURATION,
} from "src/core/constants/jwt-constants";
import { JwtUtilsService } from "src/common/jwt-utils/jwt-utils.service";
import { EncryptionKeyService } from "src/common/encryption-key/encryption-key.service";
import { RedisService } from "src/common/redis/redis.service";

@Injectable()
export class AuthService {
  private REGISTER_CACHE_DURATION: number = 25 * 60 * 1000; // 25 minutes
  private RESET_PASSWORD_CACHE_DURATION: number = 25 * 60 * 1000; // 25 minutes
  private VALIDATED_RESET_PASSWORD_CACHE_DURATION: number = 10 * 60 * 1000; // 10 minutes

  private readonly logger = new Logger(SendOtpService.name);

  constructor(
    private userRepository: UserRepository,
    private otpService: OtpService,
    private sendOtpService: SendOtpService,
    private authRetryService: AuthRetryService,
    private jwtService: JwtUtilsService,
    private encryptionKeyService: EncryptionKeyService,
    private cache: RedisService,
  ) {}

  // login
  async login(data: LoginSchema): Promise<TokensType> {
    // check if user exists in database
    const user = await this.userRepository.findByEmail(data.email);

    if (!user) {
      throw new NotFoundException("Aucun utilisateur trouvé avec cet email.");
    }

    if (!(await comparePassword(data.password!, user.password!))) {
      throw new UnauthorizedException(
        "Mot de passe incorrect. Veuillez réessayer.",
      );
    }

    // create new refreshToken and update user
    const refreshToken = await this.jwtService.createJWT(
      {},
      {
        expiresIn: JWT_REFRESH_TOKEN_DURATION,
      },
    );

    await this.userRepository.update(user.id, { refreshToken });

    // create JWT Token
    const JWTPayload = {
      id: user.id,
      email: user.email,
    };

    const accessToken = await this.jwtService.createJWT(JWTPayload, {
      expiresIn: JWT_ACCESS_TOKEN_DURATION,
    });

    return {
      accessToken,
      refreshToken,
    };
  }

  // send register otp code to user email
  async sendRegisterOtp(
    data: RegisterSchema,
  ): Promise<{ verificationToken: string }> {
    // check if user already exist
    const isUserExists = await this.userRepository.findByEmail(data.email);
    if (isUserExists) {
      throw new ConflictException(
        "Ce compte existe déja, réessayez avec un autre adresse email",
      );
    }

    // check if user email is blocked temporarily
    const isBlocked = await this.authRetryService.isBlocked(
      data.email,
      "reset_password",
    );

    if (isBlocked) {
      throw new HttpException(
        `Trop de tentatives. Veuillez réessayer dans quelques minutes`,
        HttpStatus.TOO_MANY_REQUESTS,
      );
    }

    const verificationToken = generateRandomString(32);
    const registerCacheKey = `auth:register:${verificationToken}`;

    const cacheParam = data as RegisterSchema;

    //set user into catch to use when creating user later
    await this.cache.set(
      registerCacheKey,
      cacheParam,
      this.REGISTER_CACHE_DURATION,
    );

    // generate OTP code
    const otpCode = await this.otpService.generateOTPCode({
      metadata: { email: data.email },
    });

    // send email
    await this.sendOtpService.sendRegisterEmail({
      email: data.email,
      name: data.fullName,
      otpCode,
    });

    return {
      verificationToken,
    };
  }

  // Resend OTP verification for signup
  async resendSignupOTP(
    verificationToken: string,
  ): Promise<{ verificationToken: string }> {
    const registerCacheKey = `auth:register:${verificationToken}`;

    // get cached user info
    const cacheParam = (await this.cache.get(
      registerCacheKey,
    )) as RegisterSchema;

    if (!cacheParam) {
      throw new UnauthorizedException(
        "Session expirée. Veuillez vous reconnecter.",
      );
    }

    const newVerificationToken = generateRandomString(32);

    // generate new code OTP
    const otpCode = await this.otpService.generateOTPCode({
      expiresIn: 5 * 60, // 5 minutes
      metadata: { email: cacheParam.email },
    });

    //set user into cache with new verification token
    await this.cache.set(
      "auth:register:" + newVerificationToken,
      cacheParam,
      this.REGISTER_CACHE_DURATION,
    ); // 30 minutes

    // Delete old verification token from cache
    await this.cache.del(registerCacheKey);

    await this.sendOtpService.sendRegisterEmail({
      email: cacheParam.email,
      name: cacheParam.fullName,
      otpCode,
    });

    return {
      verificationToken: newVerificationToken,
    };
  }

  // valid register otp
  async validRegisterOtp(
    otpCode: string,
    verificationToken: string,
  ): Promise<{ creationToken: string }> {
    const registerCacheKey = `auth:register:${verificationToken}`;

    // get cached user info
    const cacheParam = (await this.cache.get(
      registerCacheKey,
    )) as RegisterSchema;

    if (!cacheParam) {
      throw new UnauthorizedException(
        "Session expirée. Veuillez vous reinscrire.",
      );
    }

    // check if user email is blocked temporarily
    const isBlocked = await this.authRetryService.isBlocked(
      cacheParam.email,
      "register",
    );

    if (isBlocked) {
      throw new HttpException(
        `Trop de tentatives. Veuillez réessayer dans quelques minutes`,
        HttpStatus.TOO_MANY_REQUESTS,
      );
    }

    const isOtpCodeValid = await this.otpService.verifyOtp(
      cacheParam.email,
      otpCode,
    );

    if (!isOtpCodeValid.isValid) {
      if (isOtpCodeValid.reason == "WRONG_CODE") {
        // record faild attempt
        await this.authRetryService.recordFailAttempt(
          cacheParam.email,
          "register",
        );
      }

      throw new BadRequestException(
        isOtpCodeValid.reason == "WRONG_CODE"
          ? "Code de connexion incorrect. Veuillez réessayer."
          : "Code de connexion expiré. Veuillez vous reconnecter.",
      );
    }

    // delete old user cache
    await this.cache.del(registerCacheKey);

    // create a new key with a creation token
    const creationToken = generateRandomString(32);
    const validatedRegisterCacheKey = `auth:register:validated:${creationToken}`;

    await this.cache.set(
      validatedRegisterCacheKey,
      cacheParam,
      this.VALIDATED_RESET_PASSWORD_CACHE_DURATION,
    );

    return {
      creationToken,
    };
  }

  // create new user with password and generate access tokens
  async createNewUserAndGenerateTokens(
    creationToken: string,
    password: string,
    biometricEnabled: boolean,
  ): Promise<TokensType & { user: UserPublic }> {
    const validatedRegisterCacheKey = `auth:register:validated:${creationToken}`;

    // get cached user info using the creationToken
    const cacheParam = (await this.cache.get(
      validatedRegisterCacheKey,
    )) as RegisterSchema;

    if (!cacheParam) {
      throw new UnauthorizedException(
        "Session expirée. Veuillez réentrer votre adresse email.",
      );
    }

    // delete payload from cache
    await this.cache.del(validatedRegisterCacheKey);

    // generate refresh token
    const refreshToken = await this.jwtService.createJWT(
      {},
      {
        expiresIn: JWT_REFRESH_TOKEN_DURATION,
      },
    );

    const user = await this.userRepository.create({
      ...cacheParam,
      refreshToken,
      password: await hashPassword(password),
      biometricEnabled,
    });

    // generate Key Encryption Key
    try {
      const generatedKEK = await this.encryptionKeyService.generateKEK(
        user[0].id,
      );

      if (!generatedKEK) {
        throw new InternalServerErrorException(
          "Impossible de chiffrer le Key encryption Key",
        );
      }
    } catch (err) {
      await this.userRepository.delete(user[0].id); //rollback
      this.logger.error("Failed to create encryption keys: ", err);
      throw new InternalServerErrorException(
        "Impossible de créer les clés de chiffrement",
      );
    }

    // create JWT Token
    const JWTPayload = {
      id: user[0].id,
      email: user[0].email,
    };

    const {
      refreshToken: createdRefreshToken,
      password: createPassword,
      ...userPublic
    } = user[0];

    const accessToken = await this.jwtService.createJWT(JWTPayload, {
      expiresIn: JWT_ACCESS_TOKEN_DURATION,
    });

    return {
      user: userPublic,
      accessToken,
      refreshToken,
    };
  }

  // refresh access token using refresh token
  async refreshAccesToken(
    refreshToken: string,
  ): Promise<{ accessToken: string }> {
    // validate refresh token
    await this.jwtService.verifyToken(refreshToken);

    // get user by refresh token
    const user = await this.userRepository.findByRefreshToken(refreshToken);

    if (!user) {
      throw new UnauthorizedException("Refresh token invalide");
    }

    // create JWT Token
    const JWTPayload = {
      id: user.id,
      email: user.email,
    };

    const accessToken = await this.jwtService.createJWT(JWTPayload, {
      expiresIn: JWT_ACCESS_TOKEN_DURATION,
    });

    return {
      accessToken,
    };
  }

  // send reset password otp code to user email
  async sendResetPasswordOtp(
    email: string,
  ): Promise<{ verificationToken: string }> {
    //check if user with email exist
    const user = await this.userRepository.findByEmail(email);

    if (!user) {
      throw new NotFoundException("Aucun utilisateur trouvé avec cet email.");
    }

    // check if user email is blocked temporarily
    const isBlocked = await this.authRetryService.isBlocked(
      email,
      "reset_password",
    );

    if (isBlocked) {
      throw new HttpException(
        `Trop de tentatives. Veuillez réessayer dans quelques minutes`,
        HttpStatus.TOO_MANY_REQUESTS,
      );
    }

    const verificationToken = generateRandomString(32);
    const resetPasswordCacheKey = `auth:reset_password:${verificationToken}`;

    const cacheParam = {
      userId: user.id,
      email,
      verificationToken,
    } as CachedResetPasswordPayload;

    //set user into catch to use when reseting password later
    await this.cache.set(
      resetPasswordCacheKey,
      cacheParam,
      this.RESET_PASSWORD_CACHE_DURATION,
    );

    // generate OTP code
    const otpCode = await this.otpService.generateOTPCode({
      metadata: { email },
    });

    // send email
    await this.sendOtpService.sendResetPasswordEmail({
      email: email,
      name: user.fullName,
      otpCode,
    });

    return {
      verificationToken,
    };
  }

  // valid reset password otp
  async validateResetPasswordOtp(
    otpCode: string,
    verificationToken: string,
  ): Promise<{ resetToken: string }> {
    const resetPasswordCacheKey = `auth:reset_password:${verificationToken}`;

    // get cached user info
    const cacheParam = (await this.cache.get(
      resetPasswordCacheKey,
    )) as CachedResetPasswordPayload;

    if (!cacheParam) {
      throw new UnauthorizedException(
        "Session expirée. Veuillez réentrer votre adresse email.",
      );
    }

    // check if user email is blocked temporarily
    const isBlocked = await this.authRetryService.isBlocked(
      cacheParam.email,
      "reset_password",
    );

    if (isBlocked) {
      throw new HttpException(
        `Trop de tentatives. Veuillez réessayer dans quelques minutes`,
        HttpStatus.TOO_MANY_REQUESTS,
      );
    }

    const isOtpCodeValid = await this.otpService.verifyOtp(
      cacheParam.email,
      otpCode,
    );

    if (!isOtpCodeValid.isValid) {
      if (isOtpCodeValid.reason == "WRONG_CODE") {
        // record faild attempt
        await this.authRetryService.recordFailAttempt(
          cacheParam.email,
          "reset_password",
        );
      }

      throw new BadRequestException(
        isOtpCodeValid.reason == "WRONG_CODE"
          ? "Code de connexion incorrect. Veuillez réessayer."
          : "Code de connexion expiré. Veuillez vous reconnecter.",
      );
    }

    // delete otp code and payload from cache
    await this.cache.del(resetPasswordCacheKey);

    // create a new key with a reset token
    const resetToken = generateRandomString(32);
    const validatedResetCacheKey = `auth:reset_password:validated:${resetToken}`;

    await this.cache.set(
      validatedResetCacheKey,
      cacheParam,
      this.VALIDATED_RESET_PASSWORD_CACHE_DURATION,
    );

    return {
      resetToken,
    };
  }

  // create new password and update current user password
  async createNewPassword(resetToken: string, newPassword: string) {
    const validatedResetCacheKey = `auth:reset_password:validated:${resetToken}`;

    // get cached user info using the resetToken
    const cacheParam = (await this.cache.get(
      validatedResetCacheKey,
    )) as CachedResetPasswordPayload;

    if (!cacheParam) {
      throw new UnauthorizedException(
        "Session expirée. Veuillez réentrer votre adresse email.",
      );
    }

    // delete payload from cache
    await this.cache.del(validatedResetCacheKey);

    // update user password and invalidate refresh token
    const newHashedPassword = await hashPassword(newPassword);
    await this.userRepository.update(cacheParam.userId, {
      password: newHashedPassword,
      refreshToken: null,
    });
  }
}

import { IBaseApiReturn } from "src/core/types";
import { User } from "src/common/drizzle/schemas";

export type RegisterSchema = Required<Pick<User, "email" | "fullName">>;

export type LoginSchema = Required<Pick<User, "email" | "password">>;

export type CachedResetPasswordPayload = {
  userId: string;
  email: string;
  verificationToken: string;
};

export type RegisterEmailParams = {
  email: string;
  otpCode: string;
  name: string;
};

export type CacheRetry = {
  attempts: number;
  maxAttempts?: number;
};

export type TokensType = {
  accessToken: string;
  refreshToken: string;
};

export interface ISendRegisterOtpResponse extends IBaseApiReturn {
  verificationToken: string;
}

export interface ISendResetPasswordOtpResponse extends IBaseApiReturn {
  resetToken: string;
}

export interface IVerify2FAResponse extends IBaseApiReturn {
  creationToken: string;
}

export interface IRegisterCreatePasswordResponse extends IBaseApiReturn {
  accessToken: string;
  refreshToken: string;
}
export interface IadmingLoginResponse extends IBaseApiReturn {
  accessToken: string;
}

export interface IrefreshTokenResponse extends IBaseApiReturn {
  accessToken: string;
}

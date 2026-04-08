import { Injectable } from "@nestjs/common";
import * as types from "./types";
import { RedisService } from "src/common/redis/redis.service";
import { generateRandomDigitalNumber } from "src/core/utils/random-number-utils";

type OTPParams = {
  expiresIn?: number;
  metadata?: Record<string, string>;
};

@Injectable()
export class OtpService {
  constructor(private cache: RedisService) {}

  async generateOTPCode(params: OTPParams = {}): Promise<string> {
    const code = generateRandomDigitalNumber();

    const expiresIn = params.expiresIn ?? 5 * 60;

    if (!params.metadata?.email) {
      throw new Error("Email is required in metadata");
    }

    const cacheParam: Record<string, any> = {
      code,
      expiresIn: expiresIn * 1000, //5 minutes
      ...params.metadata,
    };

    const otpCacheKey = `otp:${params.metadata?.email}`;

    await this.cache.set(otpCacheKey, cacheParam, expiresIn * 1000);

    return code;
  }

  async verifyOtp(
    email: string,
    otpCode: string,
  ): Promise<types.verifyOtpResponse> {
    const otpCacheKey = `otp:${email}`;
    const cacheParam = await this.cache.get(otpCacheKey);

    if (!cacheParam) {
      return {
        reason: "CODE_EXPIRED",
        isValid: false,
      };
    }

    const cachedOtpCode = cacheParam["code"] as string;
    const isMatched = Number(otpCode) === Number(cachedOtpCode);

    // delete code from cache if matched
    if (isMatched) {
      await this.cache.del(otpCacheKey);
    }

    return {
      reason: isMatched ? "SUCCESS" : "WRONG_CODE",
      isValid: isMatched,
    };
  }
}

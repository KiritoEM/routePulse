import { Injectable } from "@nestjs/common";
import { CacheRetry } from "./types";
import { RedisService } from "src/common/redis/redis.service";

@Injectable()
export class AuthRetryService {
  private retryCacheDuration: number = 5 * 60 * 1000; // 5 minutes
  private blockCacheDuration: number = 5 * 60 * 1000; // 5 minutes

  constructor(private cache: RedisService) {}

  async recordFailAttempt(
    email: string,
    prefix: string,
    maxAttempts: number = 5,
  ): Promise<CacheRetry> {
    const retryCacheKey = `auth:${prefix}:retry:${email}`;
    const blockCacheKey = `auth:${prefix}:block:${email}`;

    const cacheRetry = (await this.cache.get(retryCacheKey)) as CacheRetry;

    // check if no retry in cache of an email
    if (!cacheRetry) {
      const initial = {
        attempts: 1,
        maxAttempts,
      };

      await this.cache.set(retryCacheKey, initial, this.retryCacheDuration);

      return {
        attempts: 1,
        maxAttempts,
      };
    }

    const newAttempts = cacheRetry.attempts + 1;

    console.log(
      `newAttempts: ${newAttempts} | maxAttempts: ${cacheRetry.maxAttempts}`,
    );

    // check and block if current email remaining attemps is great or equal the limit
    if (newAttempts >= (cacheRetry.maxAttempts ?? maxAttempts)) {
      await this.cache.set(
        blockCacheKey,
        {
          blockedEmail: email,
        },
        this.blockCacheDuration,
      );

      // delete retry cache
      await this.cache.del(retryCacheKey);

      return {
        attempts: 5,
        maxAttempts: cacheRetry.maxAttempts,
      };
    }

    // increment attempts
    const updatedRetry = {
      attempts: newAttempts,
      maxAttempts: cacheRetry.maxAttempts,
    } as CacheRetry;

    // increment attempts
    const ttl = (await this.cache.ttl(retryCacheKey)) as number;
    await this.cache.set(
      retryCacheKey,
      updatedRetry,
      ttl && ttl > 0 ? ttl : this.retryCacheDuration,
    );

    return {
      attempts: updatedRetry.attempts,
      maxAttempts: updatedRetry.maxAttempts,
    };
  }

  // check if an email is blocked temporarily
  async isBlocked(email: string, prefix: string): Promise<boolean> {
    const blockCacheKey = `auth:${prefix}:block:${email}`;

    const blockCacheParam = (await this.cache.get(blockCacheKey)) as CacheRetry;

    if (blockCacheParam) {
      return true;
    }

    return false;
  }
}

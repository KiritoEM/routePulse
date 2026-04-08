import { Inject, Injectable } from "@nestjs/common";
import Redis from "ioredis";

@Injectable()
export class RedisService {
  constructor(@Inject("REDIS_CLIENT") private redis: Redis) {}

  async set<T>(key: string, value: T, ttl?: number) {
    const jsonValue = JSON.stringify(value);

    if (ttl) {
      await this.redis.set(key, jsonValue, "PX", ttl);
    } else {
      await this.redis.set(key, jsonValue);
    }
  }

  async get(key: string): Promise<Record<string, any> | null> {
    const payload = await this.redis.get(key);

    const parseJson = payload ? JSON.parse(payload) : null;

    return parseJson as Record<string, any>;
  }

  async getList<T>(key: string): Promise<T[]> {
    const items = await this.redis.lrange(key, 0, -1);

    return items.map((item) => JSON.parse(item) as T);
  }

  async pushToList<T>(key: string, data: T, ttl?: number) {
    await this.redis.lpush(key, JSON.stringify(data));

    if (ttl) {
      await this.redis.expire(key, Math.floor(ttl / 1000));
    }
  }

  async del(key: string) {
    await this.redis.del(key);
  }

  async ttl(key: string): Promise<number | null> {
    const ttl = await this.redis.ttl(key);

    if (ttl < 0) return null;

    return ttl * 1000;
  }
}

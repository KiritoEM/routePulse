import { ConfigService } from "@nestjs/config";
import Redis from "ioredis";

export const redisProvider = [
  {
    provide: "REDIS_CLIENT",
    inject: [ConfigService],
    useFactory: async (configService: ConfigService): Promise<Redis> => {
      const redis = new Redis({
        host: configService.get<string>("redis.host"),
        port: configService.get<number>("redis.port"),
        password: configService.get<string>("redis.password"),
        username: configService.get<string>("redis.username"),
      });

      await new Promise<void>((resolve, reject) => {
        redis.on("connect", () => {
          console.log("✅ Redis connected successfully");
          resolve();
        });

        redis.on("error", (error) => {
          console.error("❌ Redis connection failed:", error.message);
          reject(error);
        });
      });

      return redis;
    },
  },
];

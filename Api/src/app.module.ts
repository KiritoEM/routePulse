import { Module } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import { ThrottlerModule } from "@nestjs/throttler";
import redisConfig from "./core/configs/redis.config";
import mailConfig from "./core/configs/mail.config";
import dbConfig from "./core/configs/db.config";
import jwtConfig, { jwtOptions } from "./core/configs/jwt.config";
import encryptionConfig from "./core/configs/encryption.config";
import infisicalConfig from "./core/configs/infisical.config";
import { DrizzleModule } from "./common/drizzle/drizzle.module";
import { MailModule } from "./common/mail/mail.module";
import { JwtModule } from "@nestjs/jwt";
import { OtpModule } from "./common/otp/otp.module";
import { JwtUtilsModule } from "./common/jwt-utils/jwt-utils.module";
import { EncryptionKeyModule } from "./common/encryption-key/encryption-key.module";
import { InfisicalModule } from "./common/infisical/infisical.module";
import { RedisModule } from "./common/redis/redis.module";
import { AuthModule } from './auth/auth.module';
import { UserModule } from './user/user.module';
import { DeliveryModule } from './delivery/delivery.module';
import { SupabaseModule } from './common/supabase/supabase.module';
import { ClientModule } from './client/client.module';
import { VehicleModule } from './vehicle/vehicle.module';
import supabaseConfig from "./core/configs/supabase.config";

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [
        redisConfig,
        mailConfig,
        dbConfig,
        jwtConfig,
        encryptionConfig,
        infisicalConfig,
        supabaseConfig
      ],
    }),
    ThrottlerModule.forRoot([
      {
        name: "short",
        ttl: 1000,
        limit: 3,
      },
      {
        name: "medium",
        ttl: 10000,
        limit: 20,
      },
      {
        name: "long",
        ttl: 60000,
        limit: 100,
      },
    ]),
    DrizzleModule,
    MailModule,
    JwtModule.registerAsync(jwtOptions),
    OtpModule,
    JwtUtilsModule,
    EncryptionKeyModule,
    InfisicalModule,
    RedisModule,
    AuthModule,
    UserModule,
    DeliveryModule,
    SupabaseModule,
    ClientModule,
    VehicleModule,
  ],
})
export class AppModule {}

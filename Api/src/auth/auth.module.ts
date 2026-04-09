import { Module } from "@nestjs/common";
import { AuthService } from "./auth.service";
import { AuthController } from "./auth.controller";
import { AuthRetryService } from "./auth-retry.service";
import { SendOtpService } from "./send-otp.service";
import { UserModule } from "src/user/user.module";
import { RedisModule } from "src/common/redis/redis.module";
import { JwtUtilsModule } from "src/common/jwt-utils/jwt-utils.module";
import { EncryptionKeyModule } from "src/common/encryption-key/encryption-key.module";
import { OtpModule } from "src/common/otp/otp.module";
import { MailModule } from "src/common/mail/mail.module";

@Module({
  providers: [AuthService, AuthRetryService, SendOtpService],
  controllers: [AuthController],
  imports: [
    UserModule,
    UserModule,
    RedisModule,
    JwtUtilsModule,
    EncryptionKeyModule,
    OtpModule,
    MailModule,
  ],
})
export class AuthModule {}

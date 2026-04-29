import { Module } from "@nestjs/common";
import { DeliveryService } from "./delivery.service";
import { DeliveryController } from "./delivery.controller";
import { DeliveryRepository } from "./delivery.repository";
import { EncryptionKeyModule } from "src/common/encryption-key/encryption-key.module";
import { UserModule } from "src/user/user.module";
import { SupabaseModule } from "src/common/supabase/supabase.module";
import { RedisModule } from "src/common/redis/redis.module";

@Module({
  providers: [DeliveryService, DeliveryRepository],
  controllers: [DeliveryController],
  imports: [EncryptionKeyModule, UserModule, SupabaseModule, RedisModule],
})
export class DeliveryModule {}

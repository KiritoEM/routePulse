import { Module } from "@nestjs/common";
import { EncryptionKeyService } from "./encryption-key.service";
import { InfisicalModule } from "src/common/infisical/infisical.module";

@Module({
  providers: [EncryptionKeyService],
  imports: [InfisicalModule, InfisicalModule],
  exports: [EncryptionKeyService],
})
export class EncryptionKeyModule { }

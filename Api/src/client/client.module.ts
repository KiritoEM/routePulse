import { Module } from "@nestjs/common";
import { ClientService } from "./client.service";
import { ClientController } from "./client.controller";
import { ClientRepository } from "./client.repository";
import { UserRepository } from "src/user/user.repository";
import { EncryptionKeyModule } from "src/common/encryption-key/encryption-key.module";
import { UserModule } from "src/user/user.module";

@Module({
  providers: [ClientService, ClientRepository],
  controllers: [ClientController],
  imports: [UserModule, EncryptionKeyModule],
})
export class ClientModule {}

import { Module } from "@nestjs/common";
import { infisicalProvider } from "./infisical.provider";
import { InfisicalService } from "./infisical.service";

@Module({
  providers: [...infisicalProvider, InfisicalService],
  exports: [...infisicalProvider, InfisicalService],
})
export class InfisicalModule {}

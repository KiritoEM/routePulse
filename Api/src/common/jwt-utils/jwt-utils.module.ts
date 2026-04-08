import { Global, Module } from "@nestjs/common";
import { JwtUtilsService } from "./jwt-utils.service";

@Global()
@Module({
  providers: [JwtUtilsService],
  exports: [JwtUtilsService],
})
export class JwtUtilsModule {}

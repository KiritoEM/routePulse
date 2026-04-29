import { Module } from "@nestjs/common";
import { VehicleService } from "./vehicle.service";
import { VehicleController } from "./vehicle.controller";
import { VehicleRepository } from "./vehicle.repository";
import { UserModule } from "src/user/user.module";

@Module({
  providers: [VehicleService, VehicleRepository],
  controllers: [VehicleController],
  imports: [UserModule],
})
export class VehicleModule {}

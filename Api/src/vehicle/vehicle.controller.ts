// vehicle.controller.ts
import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Post,
  UseGuards,
} from "@nestjs/common";
import { AuthGuard } from "src/core/guards/jwt.guard";
import { VehicleService } from "./vehicle.service";
import { IBaseApiReturn } from "src/core/types";
import { CreateVehicleDTO } from "./dtos/create-vehicle.dto";
import { UserReq } from "src/core/decorators/user.decorator";
import { Vehicle } from "src/common/drizzle/schemas";
import { IgetAllVehiclesResponse } from "./types";

@UseGuards(AuthGuard)
@Controller("vehicle")
export class VehicleController {
  constructor(private vehicleService: VehicleService) {}

  /** Create vehicle */
  @Post()
  @HttpCode(HttpStatus.CREATED)
  async createVehicle(
    @Body() createVehicleDTO: CreateVehicleDTO,
    @UserReq() user,
  ): Promise<IBaseApiReturn> {
    const vehicleData = {
      ...createVehicleDTO,
      plateNumber: createVehicleDTO.plateNumber ?? null,
    };

    await this.vehicleService.createVehicle(user.id, vehicleData);

    return {
      statusCode: HttpStatus.CREATED,
      message: "Véhicule créé avec succès",
    };
  }

  /** Get all vehicles */
  @Get()
  @HttpCode(HttpStatus.OK)
  async findAllVehicles(@UserReq() user): Promise<IgetAllVehiclesResponse> {
    const vehicles = await this.vehicleService.findAllVehicles(user.id);
    return {
      statusCode: HttpStatus.OK,
      message: "Véhicules récupérés avec succès",
      data: vehicles,
    };
  }
}

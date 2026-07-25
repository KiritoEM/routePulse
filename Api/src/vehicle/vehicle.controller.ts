// vehicle.controller.ts
import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Patch,
  Post,
  Query,
  UseGuards,
} from "@nestjs/common";
import { AuthGuard } from "src/core/guards/jwt.guard";
import { VehicleService } from "./vehicle.service";
import { CreateVehicleDTO } from "./dtos/create-vehicle.dto";
import { UpdateVehicleDTO } from "./dtos/update-vehicle.dto";
import { ToggleVehicleStatusDTO } from "./dtos/toggle-vehicle-status.dto";
import { GetAllVehiclesQueryDTO } from "./dtos/get-all-vehicles.dto";
import { UserReq } from "src/core/decorators/user.decorator";
import {
  ICreateVehicleResponse,
  IgetAllVehiclesResponse,
  IUpdateVehicleResponse,
} from "./types";
import { IBaseApiReturn, IBaseJWTPayload } from "src/core/types";

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
  ): Promise<ICreateVehicleResponse> {
    const vehicleData = {
      ...createVehicleDTO,
      plateNumber: createVehicleDTO.plateNumber ?? null,
    };

    const vehicle = await this.vehicleService.createVehicle(
      user.id,
      vehicleData,
    );

    return {
      statusCode: HttpStatus.CREATED,
      message: "Véhicule créé avec succès",
      data: vehicle,
    };
  }

  /** Get all vehicles, optionally filtered by availability */
  @Get()
  @HttpCode(HttpStatus.OK)
  async findAllVehicles(
    @Query() filterQuery: GetAllVehiclesQueryDTO,
    @UserReq() user,
  ): Promise<IgetAllVehiclesResponse> {
    const vehicles = await this.vehicleService.findAllVehicles(
      user.id,
      filterQuery.isActive,
    );

    return {
      statusCode: HttpStatus.OK,
      message: "Véhicules récupérés avec succès",
      data: vehicles,
    };
  }

  /** Update vehicle */
  @Patch(":id")
  @HttpCode(HttpStatus.OK)
  async updateVehicle(
    @Param("id") vehicleId: string,
    @Body() updateVehicleDTO: UpdateVehicleDTO,
    @UserReq() user: IBaseJWTPayload,
  ): Promise<IUpdateVehicleResponse> {
    const vehicle = await this.vehicleService.updateVehicle(
      user.id,
      vehicleId,
      updateVehicleDTO,
    );

    return {
      statusCode: HttpStatus.OK,
      message: "Véhicule mis à jour avec succès",
      data: vehicle,
    };
  }

  /** Activate or deactivate vehicle */
  @Patch(":id/status")
  @HttpCode(HttpStatus.OK)
  async toggleVehicleStatus(
    @Param("id") vehicleId: string,
    @Body() toggleVehicleStatusDTO: ToggleVehicleStatusDTO,
    @UserReq() user: IBaseJWTPayload,
  ): Promise<IUpdateVehicleResponse> {
    const vehicle = await this.vehicleService.toggleVehicleStatus(
      user.id,
      vehicleId,
      toggleVehicleStatusDTO.isActive,
    );

    return {
      statusCode: HttpStatus.OK,
      message: toggleVehicleStatusDTO.isActive
        ? "Véhicule rendu disponible"
        : "Véhicule désactivé",
      data: vehicle,
    };
  }

  /** Delete vehicle */
  @Delete(":id")
  @HttpCode(HttpStatus.OK)
  async deleteVehicle(
    @Param("id") vehicleId: string,
    @UserReq() user: IBaseJWTPayload,
  ): Promise<IBaseApiReturn> {
    await this.vehicleService.deleteVehicle(user.id, vehicleId);

    return {
      statusCode: HttpStatus.OK,
      message: "Véhicule supprimé avec succès",
    };
  }
}

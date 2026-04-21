import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Post,
  UseGuards,
  Query,
  Param,
} from "@nestjs/common";
import { AuthGuard } from "src/core/guards/jwt.guard";
import { CreateDeliveryDTO } from "./dtos/create-delivery.dto";
import { UserReq } from "src/core/decorators/user.decorator";
import { DeliveryService } from "./delivery.service";
import { IBaseApiReturn, IBaseJWTPayload } from "src/core/types";
import { GetAllDeliveriesQueryDTO } from "./dtos/get-all-deliveries.dto";
import { IGetAllDeliveriesResponse, IGetDeliveryResponse } from "./types";

@UseGuards(AuthGuard)
@Controller("delivery")
export class DeliveryController {
  constructor(private deliveryService: DeliveryService) {}

  /** Create a new delivery */
  @Post("")
  @HttpCode(HttpStatus.CREATED)
  async createDelivery(
    @Body() createDeliveryDTO: CreateDeliveryDTO,
    @UserReq() user: IBaseJWTPayload,
  ): Promise<IBaseApiReturn> {
    await this.deliveryService.createDelivery(user.id, createDeliveryDTO);

    return {
      statusCode: HttpStatus.CREATED,
      message: "La livraison a été créée avec succès",
    };
  }

  /** Get all deliveries of the authenticated user with optional filters */
  @Get("")
  @HttpCode(HttpStatus.OK)
  async getAllDelivery(
    @Query() filterQuery: GetAllDeliveriesQueryDTO,
    @UserReq() user: IBaseJWTPayload,
  ): Promise<IGetAllDeliveriesResponse> {
    const deliveries = await this.deliveryService.getAllDeliveries(
      user.id,
      filterQuery,
    );

    return {
      statusCode: HttpStatus.OK,
      message: "Liste des livraisons récupérée avec succès",
      total: deliveries.total,
      data: deliveries.deliveries,
    };
  }

  /** Get specific delivery */
  @Get(":deliveryId")
  @HttpCode(HttpStatus.OK)
  async getDeliveryById(
    @Param("deliveryId") deliveryId: string,
    @UserReq() user: IBaseJWTPayload,
  ): Promise<IGetDeliveryResponse> {
    const delivery = await this.deliveryService.getDeliveryById(
      user.id,
      deliveryId,
    );

    return {
      statusCode: HttpStatus.OK,
      message: "Livraison récupérée avec succès",
      data: delivery,
    };
  }
}

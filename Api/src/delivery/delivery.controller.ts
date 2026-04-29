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
  Patch,
} from "@nestjs/common";
import { AuthGuard } from "src/core/guards/jwt.guard";
import { CreateDeliveryDTO } from "./dtos/create-delivery.dto";
import { UserReq } from "src/core/decorators/user.decorator";
import { DeliveryService } from "./delivery.service";
import { IBaseApiReturn, IBaseJWTPayload } from "src/core/types";
import { GetAllDeliveriesQueryDTO } from "./dtos/get-all-deliveries.dto";
import {
  ICreateDeliveryResponse,
  IGetAllDeliveriesResponse,
  IGetDeliveryResponse,
} from "./types";
import {
  CancelDeliveryDTO,
  ReportDeliveryDTO,
} from "./dtos/update-delivery.dto";

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
  ): Promise<ICreateDeliveryResponse> {
    const delivery = await this.deliveryService.createDelivery(
      user.id,
      createDeliveryDTO,
    );

    return {
      statusCode: HttpStatus.CREATED,
      data: delivery,
      message: "La livraison a été créée avec succès",
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

  /** Start a delivery  */
  @Patch(":deliveryId/start")
  @HttpCode(HttpStatus.OK)
  async startDelivery(
    @Param("deliveryId") deliveryId: string,
  ): Promise<IBaseApiReturn> {
    await this.deliveryService.startDelivery(deliveryId);
    return {
      statusCode: HttpStatus.OK,
      message: "Livraison démarrée avec succès",
    };
  }

  /** Cancel a delivery with cancel reason */
  @Patch(":deliveryId/cancel")
  @HttpCode(HttpStatus.OK)
  async cancelDelivery(
    @Param("deliveryId") deliveryId: string,
    @Body() cancelDeliveryDTO: CancelDeliveryDTO,
    @UserReq() user: IBaseJWTPayload,
  ): Promise<IBaseApiReturn> {
    await this.deliveryService.cancelDelivery(
      user.id,
      deliveryId,
      cancelDeliveryDTO.reason,
    );
    return {
      statusCode: HttpStatus.OK,
      message: "Livraison annulée avec succès",
    };
  }

  /** Report a delivery to a new date */
  @Patch(":deliveryId/report")
  @HttpCode(HttpStatus.OK)
  async reportDelivery(
    @Param("deliveryId") deliveryId: string,
    @Body() reportDeliveryDTO: ReportDeliveryDTO,
    @UserReq() user: IBaseJWTPayload,
  ): Promise<IBaseApiReturn> {
    await this.deliveryService.reportDelivery(
      user.id,
      deliveryId,
      reportDeliveryDTO.newDate,
    );
    return {
      statusCode: HttpStatus.OK,
      message: "Livraison reportée avec succès",
    };
  }
}

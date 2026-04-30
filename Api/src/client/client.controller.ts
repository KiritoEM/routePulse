import {
  Body,
  Controller,
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
import { ClientService } from "./client.service";
import { IBaseApiReturn, IBaseJWTPayload } from "src/core/types";
import { SearchClientsByNameDTO } from "./dtos/search-client.dto";
import { ICreateClientResponse, ISearchClientResponse } from "./types";
import { UserReq } from "src/core/decorators/user.decorator";
import { CreateClientDto } from "./dtos/create-client.dto";
import { UpdateClientDto } from "./dtos/update-client.dto";

@UseGuards(AuthGuard)
@Controller("client")
export class ClientController {
  constructor(private clientService: ClientService) {}

  /** Create a new client */
  @Post()
  @HttpCode(HttpStatus.CREATED)
  async createClient(
    @Body() createClientDto: CreateClientDto,
    @UserReq() user: IBaseJWTPayload,
  ): Promise<ICreateClientResponse> {
    const client = await this.clientService.createClient(
      user.id,
      createClientDto.checkName,
      createClientDto,
    );
    return {
      statusCode: HttpStatus.CREATED,
      message: "Client créé avec succès",
      data: client,
    };
  }

  /** Search clients by name */
  @Get("search")
  @HttpCode(HttpStatus.OK)
  async searchClientsByName(
    @Query() query: SearchClientsByNameDTO,
    @UserReq() user: IBaseJWTPayload,
  ): Promise<ISearchClientResponse> {
    const clients = await this.clientService.searchClientByName(
      user.id,
      query.name,
    );
    return {
      statusCode: HttpStatus.OK,
      message: "Clients récupérés avec succès",
      data: clients,
    };
  }

  /** get all clients */
  @Get("")
  @HttpCode(HttpStatus.OK)
  async getAllClients(
    @UserReq() user: IBaseJWTPayload,
  ): Promise<ISearchClientResponse> {
    const clients = await this.clientService.getAllClients(user.id);

    return {
      statusCode: HttpStatus.OK,
      message: "Tous les clients récupérés avec succès",
      data: clients,
    };
  }

  /** Update client */
  @Patch(":clientId")
  @HttpCode(HttpStatus.OK)
  async updateClient(
    @Param("clientId") clientId: string,
    @Body() updateClientDto: UpdateClientDto,
    @UserReq() user: IBaseJWTPayload,
  ): Promise<ICreateClientResponse> {
    const clients = await this.clientService.updateClient(
      user.id,
      clientId,
      updateClientDto,
    );

    return {
      statusCode: HttpStatus.OK,
      message: "Informations client mis à jour avec succès",
      data: clients,
    };
  }
}

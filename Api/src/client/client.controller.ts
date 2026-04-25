import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
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
}

import {
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Query,
  UseGuards,
} from "@nestjs/common";
import { AuthGuard } from "src/core/guards/jwt.guard";
import { ClientService } from "./client.service";
import { IBaseApiReturn } from "src/core/types";
import { SearchClientsByNameDTO } from "./dtos/search-client.dto";
import { ISearchClientResponse } from "./types";
import { UserReq } from "src/core/decorators/user.decorator";

@UseGuards(AuthGuard)
@Controller("client")
export class ClientController {
  constructor(private clientService: ClientService) {}

  /** Search clients by name */
  @Get("search")
  @HttpCode(HttpStatus.OK)
  async searchClientsByName(
    @Query() query: SearchClientsByNameDTO,
    @UserReq() user,
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

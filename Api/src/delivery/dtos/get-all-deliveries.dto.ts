import { IntersectionType } from "@nestjs/mapped-types";
import { IsEnum, IsOptional } from "class-validator";
import {
  DeliveryPeriod,
  DeliveryStatus,
} from "src/core/constants/enums/delivery-enums";
import { PaginationDTO } from "src/core/shared-dtos/pagination.dto";
import { SortDTO } from "src/core/shared-dtos/sort.dto";

export class GetAllDeliveriesQueryDTO extends IntersectionType(
  PaginationDTO,
  SortDTO,
) {
  @IsEnum(DeliveryStatus)
  @IsOptional()
  status?: DeliveryStatus;

  @IsEnum(DeliveryPeriod)
  @IsOptional()
  period?: DeliveryPeriod;
}

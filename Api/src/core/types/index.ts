import { HttpStatus } from "@nestjs/common";
import { SortEnums } from "../constants/enums/sort-enums";

export interface IBaseApiReturn {
  statusCode: HttpStatus;
  message: string;
}

export interface IBaseJWTPayload {
  id: string;
  email: string;
  name?: string;
  biometricEnabled: boolean;
}

export interface IFilter {
  sort?: SortEnums;
}

export interface IPagination {
  limit?: number;
  page?: number;
}

import { HttpStatus } from "@nestjs/common";

export interface IBaseApiReturn {
  statusCode: HttpStatus;
  message: string;
}

export interface IBaseJWTPayload {
  id: string;
  email: string;
  name?: string;
}

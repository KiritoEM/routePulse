import { IsNumber, IsOptional, IsPositive } from "class-validator";

export class PaginationDTO {
  @IsOptional()
  @IsNumber()
  @IsPositive()
  limit?: number;

  @IsOptional()
  @IsNumber()
  @IsPositive()
  page?: number;
}

import { IsEnum, IsNumber, IsOptional, IsPositive } from "class-validator";
import { SortEnums } from "../constants/enums/sort-enums";

export class SortDTO {
  @IsEnum(SortEnums)
  @IsOptional()
  sort?: SortEnums;
}

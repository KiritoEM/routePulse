import { IsString, IsNotEmpty, MinLength } from "class-validator";

export class SearchClientsByNameDTO {
  @IsString()
  @IsNotEmpty()
  @MinLength(2)
  name!: string;
}

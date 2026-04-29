import { IsDateString, IsNotEmpty, IsString } from "class-validator";

export class ReportDeliveryDTO {
  @IsDateString()
  @IsNotEmpty()
  newDate: string;
}

export class CancelDeliveryDTO {
  @IsString()
  @IsNotEmpty()
  reason: string;
}

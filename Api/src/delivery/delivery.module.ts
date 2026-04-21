import { Module } from '@nestjs/common';
import { DeliveryService } from './delivery.service';
import { DeliveryController } from './delivery.controller';
import { DeliveryRepository } from './delivery.repository';

@Module({
  providers: [DeliveryService, DeliveryRepository],
  controllers: [DeliveryController]
})
export class DeliveryModule {}

import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/deliveries/data/models/create_delivery_dto.dart';

abstract class DeliveriesRepository {
  Future getAllDeliveries({DeliveryStatus? status});
  Future createDelivery(CreateDeliveryDto data);
}

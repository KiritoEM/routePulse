import 'package:route_pulse_mobile/core/constants/enums/enums.dart';

abstract class DeliveriesRepository {
  Future getAllDeliveries({DeliveryStatus? status});
}

import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/deliveries/data/models/create_delivery_dto.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/states/validate_delivery_state.dart';
import 'package:route_pulse_mobile/shared/states/api_reponse.dart';

abstract class DeliveriesRepository {
  Future<ApiResponse> getAllDeliveries({DeliveryStatus? status});
  Future<ApiResponse> getTodayPendingDeliveries();
  Future<ApiResponse> getDeliveriesCount(DeliveriesCountTypeEnum type);
  Future<ApiResponse> getDeliveryById(String id);
  Future<ApiResponse> createDelivery(CreateDeliveryDto data);
  Future<ApiResponse> startDelivery(String deliveryId);
  Future<ApiResponse> cancelDelivery(String deliveryId, String reason);
  Future<ApiResponse> reportDelivery(String deliveryId, String newDate);
  Future<ApiResponse> validateDelivery(
    String deliveryId,
    ValidateDeliveryState data,
  );
}

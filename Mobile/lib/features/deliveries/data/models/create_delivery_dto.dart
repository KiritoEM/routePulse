import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/states/create_delivery_state.dart';

part 'create_delivery_dto.freezed.dart';
part 'create_delivery_dto.g.dart';

@freezed
abstract class CreateDeliveryDto with _$CreateDeliveryDto {
  const factory CreateDeliveryDto({
    required String clientId,
    required String address,
    required String city,
    required List<double> location,
    required String deliveryDate,
    required String timeSlotStart,
    required String timeSlotEnd,
    required String vehicleId,
    required List<DeliveryArticle> articles,
    required String notes,
  }) = _CreateDeliveryDto;

  factory CreateDeliveryDto.fromJson(Map<String, dynamic> json) =>
      _$CreateDeliveryDtoFromJson(json);
}

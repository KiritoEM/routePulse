import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/client/domain/entities/client.dart';
import 'package:route_pulse_mobile/features/deliveries/domain/entities/delivery_item.dart';

part 'delivery.freezed.dart';

@freezed
abstract class Delivery with _$Delivery {
  const factory Delivery({
    required String id,
    required String deliveryId,
    DateTime? deliveryDate,
    required String timeSlotStart,
    required String timeSlotEnd,
    required String address,
    required List<double> location,
    @Default(DeliveryStatus.inProgress) DeliveryStatus status,
    String? notes,
    String? city,
    double? totalKm,
    String? deliveredAt,
    required String vehicleId,
    required String clientId,
    required DateTime createdAt,
    required DateTime updatedAt,

    required Client client,
    @Default([]) List<DeliveryItem> articles,
  }) = _Delivery;
}

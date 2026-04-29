import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/client/domain/entities/client.dart';
import 'package:route_pulse_mobile/features/deliveries/domain/entities/delivery_item.dart';

part 'delivery.freezed.dart';

@freezed
abstract class Delivery with _$Delivery {
  const Delivery._();

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
    String? cancelReason,
    required String userId,
    required String vehicleId,
    required String clientId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required Client client,
    @Default([]) List<DeliveryItem> articles,
    @Default(false) bool isSynced,
  }) = _Delivery;

  Map<String, dynamic> toCustomMap() => {
    'id': id,
    'deliveryId': deliveryId,
    'deliveryDate': deliveryDate?.toIso8601String(),
    'timeSlotStart': timeSlotStart,
    'timeSlotEnd': timeSlotEnd,
    'address': address,
    'location': location,
    'status': status.name,
    'notes': notes,
    'city': city,
    'totalKm': totalKm,
    'deliveredAt': deliveredAt,
    'cancelReason': cancelReason,
    'userId': userId,
    'vehicleId': vehicleId,
    'clientId': clientId,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

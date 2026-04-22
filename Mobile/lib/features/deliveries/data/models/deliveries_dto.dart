import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/client/data/models/client_dto.dart';
import 'package:route_pulse_mobile/features/client/domain/entities/client.dart';
import 'package:route_pulse_mobile/features/deliveries/domain/entities/delivery.dart';
import 'package:route_pulse_mobile/features/deliveries/domain/entities/delivery_item.dart';

class DeliveryDto {
  final String id;
  final String deliveryId;
  final String? deliveryDate;
  final String timeSlotStart;
  final String timeSlotEnd;
  final String address;
  final List<double> location;
  final DeliveryStatus status;
  final String? notes;
  final String? city;
  final double? totalKm;
  final String? deliveredAt;
  final String userId;
  final String vehicleId;
  final String clientId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<DeliveryItemDto> items;
  final Client client;

  const DeliveryDto({
    required this.id,
    required this.deliveryId,
    this.deliveryDate,
    required this.timeSlotStart,
    required this.timeSlotEnd,
    required this.address,
    required this.location,
    required this.status,
    this.notes,
    this.city,
    this.totalKm,
    this.deliveredAt,
    required this.userId,
    required this.vehicleId,
    required this.clientId,
    required this.createdAt,
    required this.updatedAt,
    required this.client,
    this.items = const [],
  });

  factory DeliveryDto.fromJson(Map<String, dynamic> json) {
    return DeliveryDto(
      id: json['id'] as String,
      deliveryId: json['deliveryId'] as String,
      deliveryDate: json['deliveryDate'] as String?,
      timeSlotStart: json['timeSlotStart'] as String,
      timeSlotEnd: json['timeSlotEnd'] as String,
      address: json['address'] as String,
      location: (json['location'] as List)
          .map((coord) => (coord as num).toDouble())
          .toList(),
      status: DeliveryStatus.fromValue(json['status'] as String? ?? 'pending'),
      notes: json['notes'] as String?,
      city: json['city'] as String,
      totalKm: (json['totalKm'] as num?)?.toDouble(),
      deliveredAt: json['deliveredAt'] as String?,
      userId: json['userId'] as String,
      vehicleId: json['vehicleId'] as String,
      clientId: json['clientId'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      client: ClientDto.fromJson(
        json['client'] as Map<String, dynamic>,
      ).toEntity(),
      items:
          (json['articles'] as List<dynamic>?)
              ?.map(
                (item) =>
                    DeliveryItemDto.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Delivery toEntity() {
    return Delivery(
      id: id,
      deliveryId: deliveryId,
      timeSlotStart: timeSlotStart,
      timeSlotEnd: timeSlotEnd,
      address: address,
      location: location,
      vehicleId: vehicleId,
      clientId: clientId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      city: city,
      client: client,
    );
  }
}

class DeliveryItemDto {
  final String id;
  final String deliveryId;
  final String name;
  final int quantity;
  final double? price;

  const DeliveryItemDto({
    required this.id,
    required this.deliveryId,
    required this.name,
    required this.quantity,
    this.price,
  });

  factory DeliveryItemDto.fromJson(Map<String, dynamic> json) {
    return DeliveryItemDto(
      id: json['id'] as String,
      deliveryId: json['deliveryId'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num?)?.toDouble(),
    );
  }

  DeliveryItem toEntity() => DeliveryItem(
    id: id,
    deliveryId: deliveryId,
    name: name,
    quantity: quantity,
    price: price,
  );
}

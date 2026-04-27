// delivery_hive_model.dart

import 'package:hive_ce/hive_ce.dart';
import 'package:route_pulse_mobile/features/deliveries/domain/entities/delivery.dart';

part 'delivery_model.g.dart';

@HiveType(typeId: 1)
class DeliveryHiveModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String deliveryId;

  @HiveField(2)
  final String deliveryDate;

  @HiveField(3)
  final String timeSlotStart;

  @HiveField(4)
  final String timeSlotEnd;

  @HiveField(5)
  final String address;

  @HiveField(6)
  final List<double> location;

  @HiveField(7)
  final String status;

  @HiveField(8)
  final String? notes;

  @HiveField(9)
  final String? city;

  @HiveField(10)
  final double? totalKm; 

  @HiveField(12)
  final String? deliveredAt;

  @HiveField(13)
  final String userId;

  @HiveField(14)
  final String vehicleId;

  @HiveField(15)
  final String clientId;

  @HiveField(16)
  final DateTime createdAt;

  @HiveField(17)
  final DateTime updatedAt;

  @HiveField(18)
  final bool isSynced;

  const DeliveryHiveModel({
    required this.id,
    required this.deliveryId,
    required this.deliveryDate,
    required this.timeSlotStart,
    required this.timeSlotEnd,
    required this.address,
    required this.location,
    this.status = 'pending',
    this.notes,
    this.city,
    this.totalKm,
    this.deliveredAt,
    required this.userId,
    required this.vehicleId,
    required this.clientId,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = true
  });

  factory DeliveryHiveModel.fromEntity(Delivery delivery, String userId) =>
      DeliveryHiveModel(
        id: delivery.id,
        deliveryId: delivery.deliveryId,
        deliveryDate: delivery.deliveryDate.toString(),
        timeSlotStart: delivery.timeSlotStart,
        timeSlotEnd: delivery.timeSlotEnd,
        address: delivery.address,
        location: delivery.location,
        status: delivery.status.value,
        notes: delivery.notes,
        city: delivery.city,
        totalKm: delivery.totalKm,
        deliveredAt: delivery.deliveredAt,
        userId: userId,
        vehicleId: delivery.vehicleId,
        clientId: delivery.clientId,
        createdAt: delivery.createdAt,
        updatedAt: delivery.updatedAt,
      );

  factory DeliveryHiveModel.fromMap(Map<String, dynamic> map, String userId) =>
      DeliveryHiveModel(
        id: map['id'] as String,
        deliveryId: map['deliveryId'] as String,
        deliveryDate: map['deliveryDate'] as String,
        timeSlotStart: map['timeSlotStart'] as String,
        timeSlotEnd: map['timeSlotEnd'] as String,
        address: map['address'] as String,
        location: (map['location'] as List)
            .map((coord) => (coord as num).toDouble())
            .toList(),
        notes: map['notes'] as String?,
        city: map['city'] as String?,
        deliveredAt: map['deliveredAt'] as String?,
        userId: userId,
        vehicleId: map['vehicleId'] as String,
        clientId: map['clientId'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String) ?? DateTime.now(),
        updatedAt: DateTime.parse(map['updatedAt'] as String) ?? DateTime.now(),
      );
}

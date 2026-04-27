import 'package:hive_ce/hive_ce.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/vehicle/domain/entities/vehicle.dart';

part 'vehicle_model.g.dart';

@HiveType(typeId: 4)
class VehicleHiveModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String type;

  @HiveField(3)
  final String? plateNumber;

  @HiveField(4)
  final bool isActive;

  @HiveField(5)
  final String userId;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime updatedAt;

  const VehicleHiveModel({
    required this.id,
    required this.name,
    this.type = 'moto',
    this.plateNumber,
    this.isActive = true,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VehicleHiveModel.fromEntity(Vehicle vehicle, String userId) =>
      VehicleHiveModel(
        id: vehicle.id,
        name: vehicle.name,
        type: vehicle.type.value,
        plateNumber: vehicle.plateNumber,
        isActive: vehicle.isActive,
        userId: userId,
        createdAt: vehicle.createdAt,
        updatedAt: vehicle.updatedAt,
      );

  Vehicle toEntity() => Vehicle(
    id: id,
    name: name,
    type: VehicleType.fromValue(type),
    plateNumber: plateNumber,
    isActive: isActive,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

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

  @HiveField(8)
  final bool isSynced;

  const VehicleHiveModel({
    required this.id,
    required this.name,
    this.type = 'moto',
    this.plateNumber,
    this.isActive = true,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = true,
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

  factory VehicleHiveModel.fromMap(Map<String, dynamic> map, String userId) =>
      VehicleHiveModel(
        id: map['id'] as String,
        name: map['name'] as String,
        type: map['type'] as String? ?? 'moto',
        plateNumber: map['plateNumber'] as String?,
        isActive: map['isActive'] as bool? ?? true,
        userId: userId,
        createdAt: DateTime.parse(map['createdAt'] as String),
        updatedAt: DateTime.parse(map['updatedAt'] as String),
        isSynced: map['isSynced'] as bool? ?? true,
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'plateNumber': plateNumber,
      'isActive': isActive,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isSynced': isSynced,
    };
  }

  VehicleHiveModel copyWith({
    String? id,
    String? name,
    String? type,
    String? plateNumber,
    bool? isActive,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return VehicleHiveModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      plateNumber: plateNumber ?? this.plateNumber,
      isActive: isActive ?? this.isActive,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}

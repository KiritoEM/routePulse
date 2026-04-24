// features/vehicle/data/dtos/vehicle.dto.dart
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/vehicle/domain/entities/vehicle.dart';

class VehicleDto {
  final String id;
  final String name;
  final String type;
  final String? plateNumber;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const VehicleDto({
    required this.id,
    required this.name,
    required this.type,
    this.plateNumber,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VehicleDto.fromJson(Map<String, dynamic> json) => VehicleDto(
    id: json['id'] as String,
    name: json['name'] as String,
    type: json['type'] as String,
    plateNumber: json['plateNumber'] as String?,
    isActive: json['isActive'] as bool? ?? true,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
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

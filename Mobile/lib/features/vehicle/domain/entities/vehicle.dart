import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';

part 'vehicle.freezed.dart';

@freezed
abstract class Vehicle with _$Vehicle {
  const factory Vehicle({
    required String id,
    required String name,
    @Default(VehicleType.moto) VehicleType type,
    String? plateNumber,
    @Default(true) bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Vehicle;
}

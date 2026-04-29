import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_vehicle_state.freezed.dart';
part 'update_vehicle_state.g.dart';

@freezed
abstract class UpdateVehicleState with _$UpdateVehicleState {
  const factory UpdateVehicleState({
    String? name,
    String? type,
    String? plateNumber,
  }) = _UpdateVehicleState;

  const UpdateVehicleState._();

  factory UpdateVehicleState.fromJson(Map<String, dynamic> json) =>
      _$UpdateVehicleStateFromJson(json);

  factory UpdateVehicleState.fromMap(Map<String, dynamic> map) =>
      UpdateVehicleState.fromJson(map);

  Map<String, dynamic> toMap() => toJson();
}

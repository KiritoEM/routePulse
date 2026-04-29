import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_vehicle_state.freezed.dart';
part 'create_vehicle_state.g.dart';

@freezed
abstract class CreateVehicleState with _$CreateVehicleState {
  const factory CreateVehicleState({
    required String name,
    required String type,
    String? plateNumber,
  }) = _CreateVehicleState;

  const CreateVehicleState._();

  factory CreateVehicleState.fromJson(Map<String, dynamic> json) =>
      _$CreateVehicleStateFromJson(json);

  factory CreateVehicleState.fromMap(Map<String, dynamic> map) =>
      CreateVehicleState.fromJson(map);

  Map<String, dynamic> toMap() => toJson();
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_client_state.freezed.dart';
part 'update_client_state.g.dart';

@freezed
abstract class UpdateClientState with _$UpdateClientState {
  const factory UpdateClientState({
    String? name,
    String? phoneNumber,
    String? address,
    String? city,
    @Default([]) List<double> location,
  }) = _UpdateClientState;

  const UpdateClientState._();

  factory UpdateClientState.fromJson(Map<String, dynamic> json) =>
      _$UpdateClientStateFromJson(json);

  factory UpdateClientState.fromMap(Map<String, dynamic> map) =>
      UpdateClientState.fromJson(map);

  Map<String, dynamic> toMap() => toJson();
}

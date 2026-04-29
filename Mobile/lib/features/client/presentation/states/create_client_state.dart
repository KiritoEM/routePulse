import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_client_state.freezed.dart';
part 'create_client_state.g.dart';

@freezed
abstract class CreateClientState with _$CreateClientState {
  const factory CreateClientState({
    required String name,
    String? phoneNumber,
    String? address,
    String? city,
    @Default([]) List<double> location,
  }) = _CreateClientState;

  const CreateClientState._();

  factory CreateClientState.fromJson(Map<String, dynamic> json) =>
      _$CreateClientStateFromJson(json);

  factory CreateClientState.fromMap(Map<String, dynamic> map) =>
      CreateClientState.fromJson(map);

  Map<String, dynamic> toMap() => toJson();
}

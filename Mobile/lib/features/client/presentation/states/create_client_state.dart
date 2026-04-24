import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_client_state.freezed.dart';
part 'create_client_state.g.dart';

@freezed
abstract class CreateClientState with _$CreateClientState {
  const factory CreateClientState({
    required String name,
    String? email,
    String? phone,
    String? address,
    @Default([]) List<double> location,
  }) = _CreateClientState;

  factory CreateClientState.fromJson(Map<String, dynamic> json) =>
      _$CreateClientStateFromJson(json);
}

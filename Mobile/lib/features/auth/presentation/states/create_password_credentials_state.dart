import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_password_credentials_state.freezed.dart';
part 'create_password_credentials_state.g.dart';

@freezed
abstract class CreatePasswordCredentialsState
    with _$CreatePasswordCredentialsState {
  const factory CreatePasswordCredentialsState({
    required String password,
    required String creationToken,
    required bool biometricEnabled,
  }) = _CreatePasswordCredentialsState;

  factory CreatePasswordCredentialsState.fromJson(Map<String, dynamic> json) =>
      _$CreatePasswordCredentialsStateFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_credentials_state.freezed.dart';
part 'login_credentials_state.g.dart';

@freezed
abstract class LoginCredentialsState with _$LoginCredentialsState {
  const factory LoginCredentialsState({
    required String email,
    required String password,
  }) = _LoginCredentialsState;

  factory LoginCredentialsState.fromJson(Map<String, dynamic> json) =>
      _$LoginCredentialsStateFromJson(json);
}

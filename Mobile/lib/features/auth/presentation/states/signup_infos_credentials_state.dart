import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_infos_credentials_state.freezed.dart';
part 'signup_infos_credentials_state.g.dart';

@freezed
abstract class SignupInfosCredentialsState with _$SignupInfosCredentialsState {
  const factory SignupInfosCredentialsState({
    required String email,
    required String fullName,
  }) = _SignupInfosCredentialsState;

  factory SignupInfosCredentialsState.fromJson(Map<String, dynamic> json) =>
      _$SignupInfosCredentialsStateFromJson(json);
}

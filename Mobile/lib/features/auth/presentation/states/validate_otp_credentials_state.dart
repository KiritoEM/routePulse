import 'package:freezed_annotation/freezed_annotation.dart';

part 'validate_otp_credentials_state.freezed.dart';
part 'validate_otp_credentials_state.g.dart';

@freezed
abstract class ValidateOtpCredentialsState with _$ValidateOtpCredentialsState {
  const factory ValidateOtpCredentialsState({
    required String code,
    required String verificationToken,
  }) = _ValidateOtpCredentialsState;

  factory ValidateOtpCredentialsState.fromJson(Map<String, dynamic> json) =>
      _$ValidateOtpCredentialsStateFromJson(json);
}

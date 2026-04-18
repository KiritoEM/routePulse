import 'package:freezed_annotation/freezed_annotation.dart';

part 'resend_otp_credentials_state.freezed.dart';
part 'resend_otp_credentials_state.g.dart';

@freezed
abstract class ResendOtpCredentialsState with _$ResendOtpCredentialsState {
  const factory ResendOtpCredentialsState({
    required String verificationToken,
  }) = _ResendOtpCredentialsState;

  factory ResendOtpCredentialsState.fromJson(Map<String, dynamic> json) =>
      _$ResendOtpCredentialsStateFromJson(json);
}

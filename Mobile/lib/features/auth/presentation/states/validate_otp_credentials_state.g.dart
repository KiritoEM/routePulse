// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validate_otp_credentials_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ValidateOtpCredentialsState _$ValidateOtpCredentialsStateFromJson(
  Map<String, dynamic> json,
) => _ValidateOtpCredentialsState(
  code: json['code'] as String,
  verificationToken: json['verificationToken'] as String,
);

Map<String, dynamic> _$ValidateOtpCredentialsStateToJson(
  _ValidateOtpCredentialsState instance,
) => <String, dynamic>{
  'code': instance.code,
  'verificationToken': instance.verificationToken,
};

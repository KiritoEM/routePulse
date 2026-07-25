import 'package:route_pulse_mobile/core/local_db/models/user_model.dart';

class SignupDto {
  final String id;
  final String email;
  final String password;
  final String? fullName;
  final bool biometricEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  SignupDto({
    required this.id,
    required this.email,
    required this.password,
    this.fullName,
    this.biometricEnabled = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SignupDto.fromJson(Map<String, dynamic> json) {
    return SignupDto(
      id: json['id'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      fullName: json['fullName'] as String?,
      biometricEnabled: json['biometricEnabled'] == true,
      createdAt: DateTime.tryParse('${json['createdAt']}') ?? DateTime.now(),
      updatedAt: DateTime.tryParse('${json['updatedAt']}') ?? DateTime.now(),
    );
  }

  UserHiveModel toHiveModel() => UserHiveModel(
    id: id,
    email: email,
    password: password,
    fullName: fullName,
    biometricEnabled: biometricEnabled,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

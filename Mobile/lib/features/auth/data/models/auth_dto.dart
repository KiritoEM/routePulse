import 'package:route_pulse_mobile/core/local_db/models/user_model.dart';

class SignupDto {
  final String id;
  final String email;
  final String password;
  final bool biometricEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  SignupDto({
    required this.id,
    required this.email,
    required this.password,
    this.biometricEnabled = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SignupDto.fromJson(Map<String, dynamic> json) {
    return SignupDto(
      id: json['id'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      biometricEnabled: json['biometricEnabled'] as bool,
      createdAt: json['createdAt'] ?? DateTime.now(),
      updatedAt: json['updatedAt'] ?? DateTime.now(),
    );
  }

  UserHiveModel toHiveModel() => UserHiveModel(
    id: id,
    email: email,
    password: password,
    biometricEnabled: biometricEnabled,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

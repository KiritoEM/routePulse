import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive_ce.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@HiveType(typeId: 0)
@freezed
abstract class User with _$User{
  const factory User ({
    @HiveField(0) required String id,
    @HiveField(1) required String email,
    @HiveField(2) required String password,
    @HiveField(3) @Default(false) bool biometricEnabled,
    @HiveField(4) required DateTime createdAt,
    @HiveField(5) required DateTime updatedAt,
    @HiveField(6) @Default(false) bool isDeleted,
  }) = _User;

  factory User.create({
    required String id,
    required String email,
    required String password,
    bool biometricEnabled = false,
    bool isDeleted = false,
  }) {
    final now = DateTime.now();
    return User(
      id: id,
      email: email,
      password: password,
      biometricEnabled: biometricEnabled,
      createdAt: now,
      updatedAt: now,
      isDeleted: isDeleted,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

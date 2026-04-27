import 'package:hive_ce/hive_ce.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserHiveModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String password;

  @HiveField(3)
  final bool biometricEnabled;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime updatedAt;

  @HiveField(6)
  final bool isDeleted;

  const UserHiveModel({
    required this.id,
    required this.email,
    required this.password,
    this.biometricEnabled = false,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
  });
}

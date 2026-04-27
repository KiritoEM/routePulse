import 'package:hive_ce/hive_ce.dart';
import 'package:route_pulse_mobile/features/client/domain/entities/client.dart';

part 'client_model.g.dart';

@HiveType(typeId: 3)
class ClientHiveModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String phoneNumber;

  @HiveField(3)
  final String address;

  @HiveField(4)
  final List<double> location;

  @HiveField(5)
  final String? city;

  @HiveField(7)
  final String userId;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final DateTime updatedAt;

  @HiveField(10)
  final bool isDeleted;

  @HiveField(11)
  final DateTime? deletedAt;

  @HiveField(12)
  final bool isSynced;

  const ClientHiveModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.location,
    this.city,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
    this.deletedAt,
    this.isSynced = true
  });

  factory ClientHiveModel.fromEntity(Client client, String userId) =>
      ClientHiveModel(
        id: client.id,
        name: client.name,
        phoneNumber: client.phoneNumber,
        address: client.address,
        location: client.location ?? [],
        city: client.city,
        userId: userId,
        createdAt: client.createdAt,
        updatedAt: client.updatedAt,
      );

  factory ClientHiveModel.fromMap(Map<String, dynamic> map, String userId) =>
      ClientHiveModel(
        id: map['id'] as String,
        name: map['name'] as String,
        phoneNumber: map['phoneNumber'] as String,
        address: map['address'] as String,
        location: (map['location'] as List)
            .map((coord) => (coord as num).toDouble())
            .toList(),
        city: map['city'] as String?,
        userId: userId,
        createdAt: DateTime.parse(map['createdAt'] as String),
        updatedAt: DateTime.parse(map['updatedAt'] as String),
        isDeleted: map['isDeleted'] as bool? ?? false,
        deletedAt: map['deletedAt'] != null
            ? DateTime.parse(map['deletedAt'] as String)
            : null,
      );

  Client toEntity() => Client(
    id: id,
    name: name,
    phoneNumber: phoneNumber,
    address: address,
    location: location,
    city: city,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

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
  final String? address;

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
    this.address,
    required this.location,
    this.city,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
    this.deletedAt,
    this.isSynced = true,
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
        address: map['address'] as String?,
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
      'location': location,
      'city': city,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isDeleted': isDeleted,
      'deletedAt': deletedAt?.toIso8601String(),
      'isSynced': isSynced,
    };
  }

  ClientHiveModel copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? address,
    List<double>? location,
    String? city,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
    bool? isSynced,
  }) {
    return ClientHiveModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      location: location ?? this.location,
      city: city ?? this.city,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

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

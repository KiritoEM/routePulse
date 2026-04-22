import 'package:route_pulse_mobile/features/client/domain/entities/client.dart';

class ClientDto {
  final String id;
  final String name;
  final String phoneNumber;
  final String address;
  final List<double>? location;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ClientDto({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClientDto.fromJson(Map<String, dynamic> json) => ClientDto(
    id: json['id'] as String,
    name: json['name'] as String,
    phoneNumber: json['phoneNumber'] as String,
    address: json['address'] as String,
    location: (json['location'] as List)
        .map((coord) => (coord as num).toDouble())
        .toList(),

    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  Client toEntity() => Client(
    id: id,
    name: name,
    phoneNumber: phoneNumber,
    address: address,
    location: location,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'client.freezed.dart';

@freezed
abstract class Client with _$Client {
  const factory Client({
    required String id,
    required String name,
    required String phoneNumber,
    String? address,
    List<double>? location,
    String? city,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Client;
}

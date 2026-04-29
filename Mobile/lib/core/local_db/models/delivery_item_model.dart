import 'package:hive_ce/hive_ce.dart';
import 'package:route_pulse_mobile/features/deliveries/domain/entities/delivery_item.dart';
import 'package:uuid/uuid.dart';

part 'delivery_item_model.g.dart';

@HiveType(typeId: 2)
class DeliveryItemHiveModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int quantity;

  @HiveField(3)
  final double? price;

  @HiveField(4)
  final String deliveryId;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime updatedAt;

  const DeliveryItemHiveModel({
    required this.id,
    required this.name,
    this.quantity = 1,
    this.price,
    required this.deliveryId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeliveryItemHiveModel.fromEntity(DeliveryItem item) =>
      DeliveryItemHiveModel(
        id: item.id,
        name: item.name,
        quantity: item.quantity,
        price: item.price,
        deliveryId: item.deliveryId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'deliveryId': deliveryId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory DeliveryItemHiveModel.fromMap(Map<String, dynamic> map) {
    final now = DateTime.now();
    return DeliveryItemHiveModel(
      id: map['id'] as String? ?? const Uuid().v4(),
      name: map['name'] as String,
      quantity: map['quantity'] as int? ?? 1,
      price: (map['price'] as num?)?.toDouble(),
      deliveryId: map['deliveryId'] as String,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : now,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : now,
    );
  }
}

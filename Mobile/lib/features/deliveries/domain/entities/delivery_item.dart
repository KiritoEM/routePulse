import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery_item.freezed.dart';

@freezed
abstract class DeliveryItem with _$DeliveryItem {
  const factory DeliveryItem({
    required String id,
    required String deliveryId,
    required String name,
    required int quantity,
    double? price,
  }) = _DeliveryItem;
}

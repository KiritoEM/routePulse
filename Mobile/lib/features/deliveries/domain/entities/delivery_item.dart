import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/states/create_delivery_state.dart';

part 'delivery_item.freezed.dart';
part 'delivery_item.g.dart';

@freezed
abstract class DeliveryItem with _$DeliveryItem {
  const DeliveryItem._();

  const factory DeliveryItem({
    required String id,
    required String deliveryId,
    required String name,
    required int quantity,
    @Default(null) ArticleFile? image,
    @Default(null) double? price,
  }) = _DeliveryItem;

  factory DeliveryItem.fromJson(Map<String, dynamic> json) =>
      _$DeliveryItemFromJson(json);

  Map<String, dynamic> toMap() => toJson();
}

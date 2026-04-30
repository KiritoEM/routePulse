import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/states/create_delivery_state.dart';

part 'validate_delivery_state.freezed.dart';
part 'validate_delivery_state.g.dart';

@freezed
abstract class ValidateDeliveryState with _$ValidateDeliveryState {
  const factory ValidateDeliveryState({
    required ArticleFile file,
    required double totalKm,
    required String deliveredAt,
  }) = _ValidateDeliveryState;

  factory ValidateDeliveryState.fromJson(Map<String, dynamic> json) =>
      _$ValidateDeliveryStateFromJson(json);
}

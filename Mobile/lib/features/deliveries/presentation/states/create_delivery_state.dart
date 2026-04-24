import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_delivery_state.freezed.dart';
part 'create_delivery_state.g.dart';

@freezed
abstract class ArticleFile with _$ArticleFile {
  const factory ArticleFile({
    required String file, // base64
    required String originalName,
    required String mimeType,
    required int size,
  }) = _ArticleFile;

  factory ArticleFile.fromJson(Map<String, dynamic> json) =>
      _$ArticleFileFromJson(json);
}

@freezed
abstract class DeliveryArticle with _$DeliveryArticle {
  const factory DeliveryArticle({
    required String name,
    required int quantity,
    required double price,
    ArticleFile? file,
  }) = _DeliveryArticle;

  factory DeliveryArticle.fromJson(Map<String, dynamic> json) =>
      _$DeliveryArticleFromJson(json);
}

@freezed
abstract class CreateDeliveryState with _$CreateDeliveryState {
  const factory CreateDeliveryState({
    @Default('') String clientId,
    @Default('') String address,
    @Default([]) List<double> location,

    String? deliveryDate,
    @Default('') String timeSlotStart,
    @Default('') String timeSlotEnd,
    @Default('') String vehicleId,

    @Default([]) List<DeliveryArticle> articles,

    @Default('') String notes,

    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    String? error,
  }) = _CreateDeliveryState;

  factory CreateDeliveryState.fromJson(Map<String, dynamic> json) =>
      _$CreateDeliveryStateFromJson(json);
}

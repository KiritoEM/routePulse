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
  const DeliveryArticle._();

  const factory DeliveryArticle({
    required String name,
    required int quantity,
    required double price,
    ArticleFile? file,
  }) = _DeliveryArticle;

  factory DeliveryArticle.fromJson(Map<String, dynamic> json) =>
      _$DeliveryArticleFromJson(json);

  Map<String, dynamic> toMap() => toJson();
}

@freezed
abstract class CreateDeliveryState with _$CreateDeliveryState {
  const factory CreateDeliveryState({
    @Default('') String clientId,
    @Default('') String clientName,
    @Default('') String address,
    @Default([]) List<double> location,
    @Default('Antananrivo') String city,
    String? deliveryDate,
    @Default('') String timeSlotStart,
    @Default('') String timeSlotEnd,
    @Default('') String vehicleId,
    @Default([]) List<DeliveryArticle> articles,
    @Default('') String notes,
    @Default(null) String? errorMessage,
    @Default(false) bool isLoading,
    @Default(false) bool hasError,
  }) = _CreateDeliveryState;

  factory CreateDeliveryState.fromJson(Map<String, dynamic> json) =>
      _$CreateDeliveryStateFromJson(json);
}

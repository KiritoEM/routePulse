import 'package:flutter/rendering.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/features/deliveries/data/deliveries_repository_impl.dart';
import 'package:route_pulse_mobile/features/deliveries/data/models/create_delivery_dto.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/states/create_delivery_state.dart';
import 'package:route_pulse_mobile/shared/services/geocoding_service.dart';

part 'create_delivery_notifier.g.dart';

@Riverpod(keepAlive: true)
class CreateDeliveryNotifier extends _$CreateDeliveryNotifier {
  final DeliveriesRepositoryImpl _deliveryRepository =
      DeliveriesRepositoryImpl();

  @override
  CreateDeliveryState build() => const CreateDeliveryState();

  // step 1
  void setClientInfo({
    required String clientId,
    required String clientName,
    required String address,
    required double lat,
    required double lng,
  }) {
    state = state.copyWith(
      clientName: clientName,
      clientId: clientId,
      address: address,
      location: [lat, lng],
    );
  }

  // step 2
  void setSchedule({
    required String deliveryDate,
    required String timeSlotStart,
    required String timeSlotEnd,
    required String vehicleId,
  }) {
    state = state.copyWith(
      deliveryDate: deliveryDate,
      timeSlotStart: timeSlotStart,
      timeSlotEnd: timeSlotEnd,
      vehicleId: vehicleId,
    );
  }

  // Step 3
  void addArticle(DeliveryArticle article) {
    state = state.copyWith(articles: [...state.articles, article]);
  }

  void removeArticle(int index) {
    final updated = [...state.articles]..removeAt(index);
    state = state.copyWith(articles: updated);
  }

  // Step 4
  void setNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  // submit and create delivery
  Future<void> submit() async {
    state = state.copyWith(isLoading: true);

    final CreateDeliveryDto deliveryDTO = CreateDeliveryDto(
      clientId: state.clientId,
      address: state.address,
      location: state.location,
      deliveryDate: state.deliveryDate ?? '',
      timeSlotStart: state.timeSlotStart,
      timeSlotEnd: state.timeSlotEnd,
      vehicleId: state.vehicleId,
      articles: state.articles,
      notes: state.notes,
      city:
          (await GeocodingService.getCityFromCoordinates(
            lat: state.location[0],
            lng: state.location[1],
          )) ??
          'Antananarivo',
    );

    final response = await _deliveryRepository.createDelivery(deliveryDTO);

    if (response.hasError == true) {
      state = state.copyWith(
        hasError: true,
        errorMessage: response.message ?? 'Erreur inconnue',
        isLoading: false,
      );

      return;
    }

    state = state.copyWith(
      isLoading: false,
      hasError: false,
      errorMessage: null,
    );
  }
}

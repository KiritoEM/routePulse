import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/states/create_delivery_state.dart';

part 'create_delivery_notifier.g.dart';

@Riverpod(keepAlive: true)
class CreateDeliveryNotifier extends _$CreateDeliveryNotifier {
  @override
  CreateDeliveryState build() => const CreateDeliveryState();
  
  // step 1
  void setClientInfo({
    required String clientId,
    required String address,
    required double lat,
    required double lng,
  }) {
    state = state.copyWith(
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
}

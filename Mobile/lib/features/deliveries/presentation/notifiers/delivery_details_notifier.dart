import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/deliveries/data/deliveries_repository_impl.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

part 'delivery_details_notifier.g.dart';

@riverpod
class DeliveryDetailsNotifier extends _$DeliveryDetailsNotifier {
  final DeliveriesRepositoryImpl _deliveriesRepository =
      DeliveriesRepositoryImpl();

  Future<void> _fetchDeliveryById(String id) async {
    state = HttpState.loading();

    final response = await _deliveriesRepository.getDeliveryById(id);

    if (response.isSucess) {
      state = HttpState.success(data: response.data);
      return;
    }

    state = HttpState.error(
      errorType: response.errorType ?? NetworkErrorType.server,
      message: response.message ?? 'Impossible de recuperer la livraison',
    );
  }

  Future<void> refetch(String id) async {
    state = HttpState.loading();

    await _fetchDeliveryById(id);
  }

  @override
  HttpState build(String id) {
    _fetchDeliveryById(id);

    return HttpState.loading();
  }
}

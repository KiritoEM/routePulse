import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/deliveries/data/deliveries_repository_impl.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

part 'deliveries_pending_notifier.g.dart';

@riverpod
class DeliveriesPendingNotifier extends _$DeliveriesPendingNotifier {
  final DeliveriesRepositoryImpl _deliveriesRepository =
      DeliveriesRepositoryImpl();

  void startLoading() {
    state = HttpState.loading();
  }

  void stopLoading() {
    state = HttpState.init();
  }

  Future<void> _fetchDeliveriesPending() async {
    state = HttpState.loading();

    final response = await _deliveriesRepository.getTodayPendingDeliveries();

    if (response.isSucess) {
      state = HttpState.success(data: response.data);
      return;
    }

    state = HttpState.error(
      errorType: response.errorType ?? NetworkErrorType.server,
      message: response.message ?? 'Impossible de recuperer les livraisons',
    );
  }

  Future<void> refetch() async {
    state = HttpState.loading();

    await _fetchDeliveriesPending();
  }

  @override
  HttpState build() {
    _fetchDeliveriesPending();

    return HttpState.loading();
  }
}

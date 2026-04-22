import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/deliveries/data/deliveries_repository_impl.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

part 'deliveries_list_notifier.g.dart';

@riverpod
class DeliveriesListNotifier extends _$DeliveriesListNotifier {
  DeliveriesRepositoryImpl _deliveriesRepository = DeliveriesRepositoryImpl();

  Future _fetchDeliveriesList() async {
    state = HttpState.loading();

    final response = await _deliveriesRepository.getAllDeliveries();

    if (response.isSucess) {
      state = HttpState.success(data: response.data);
      return;
    }

    state = HttpState.error(
      errorType: response.errorType ?? NetworkErrorType.server,
      message: response.message ?? 'Impossible de recuperer les livraisons',
    );
  }

  @override
  HttpState build() {
    _fetchDeliveriesList();

    return HttpState.loading();
  }
}

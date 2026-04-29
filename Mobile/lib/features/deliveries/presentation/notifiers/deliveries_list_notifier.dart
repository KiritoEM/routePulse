import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/deliveries/data/deliveries_repository_impl.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/notifiers/deliveries_filter_notifier.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

part 'deliveries_list_notifier.g.dart';

@riverpod
class DeliveriesListNotifier extends _$DeliveriesListNotifier {
  final DeliveriesRepositoryImpl _deliveriesRepository =
      DeliveriesRepositoryImpl();

  void startLoading() {
    state = HttpState.loading();
  }

  void stopLoading() {
    state = HttpState.init();
  }

  Future<void> _fetchDeliveriesList(
    DeliveryStatus status,
    SortFilterEnum? sort,
  ) async {
    state = HttpState.loading();
    await Future.delayed(const Duration(milliseconds: 500));

    final response = await _deliveriesRepository.getAllDeliveries(
      status: status == DeliveryStatus.all ? null : status,
      sort: sort,
    );

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
    final filter = ref.read(deliveriesFilterProvider);

    state = HttpState.loading();

    await _fetchDeliveriesList(filter['status'], filter['sort']);
  }

  @override
  HttpState build() {
    final filter = ref.watch(deliveriesFilterProvider);

    _fetchDeliveriesList(filter['status'], filter['sort']);

    return HttpState.loading();
  }
}

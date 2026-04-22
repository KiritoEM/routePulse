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

  Future _fetchDeliveriesList(
    DeliveryStatus status,
    SortFilterEnum? sort,
    bool Function() isCancelled,
  ) async {
    state = HttpState.loading();
    await Future.delayed(const Duration(milliseconds: 500));

    if (isCancelled()) return;

    final response = await _deliveriesRepository.getAllDeliveries(
      status: status == DeliveryStatus.all ? null : status,
      sort: sort,
    );

    if (isCancelled()) return;

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
    final filter = ref.watch(deliveriesFilterProvider);

    bool cancelled = false;
    ref.onDispose(() => cancelled = true);

    _fetchDeliveriesList(filter['status'], filter['sort'], () => cancelled);

    return HttpState.loading();
  }
}

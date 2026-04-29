import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';

part 'deliveries_filter_notifier.g.dart';

@riverpod
class DeliveriesFilterNotifier extends _$DeliveriesFilterNotifier {
  @override
  Map<String, dynamic> build() => {
    'status': DeliveryStatus.all,
    'sort': SortFilterEnum.creationDate,
  };

  void setFilter({Object? status, Object? sort}) {
    state = {...state, 'status': ?status, 'sort': ?sort};
  }
}

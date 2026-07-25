import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';

part 'deliveries_filter_notifier.g.dart';

@riverpod
class DeliveriesFilterNotifier extends _$DeliveriesFilterNotifier {
  static const Map<String, dynamic> _defaultFilter = {
    'status': DeliveryStatus.all,
    'sort': SortFilterEnum.creationDate,
    'period': PeriodFilterEnum.today,
  };

  @override
  Map<String, dynamic> build() => {..._defaultFilter};

  void setFilter({Object? status, Object? sort, Object? period}) {
    state = {...state, 'status': ?status, 'sort': ?sort, 'period': ?period};
  }

  // reset only filters handled by the bottomsheet
  void reset() {
    state = {
      ...state,
      'sort': _defaultFilter['sort'],
      'period': _defaultFilter['period'],
    };
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/deliveries/data/deliveries_repository_impl.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

part 'deliveries_count_notifier.g.dart';

@riverpod
class DeliveriesCountNotifier extends _$DeliveriesCountNotifier {
  final DeliveriesRepositoryImpl _deliveriesRepository =
      DeliveriesRepositoryImpl();

  void startLoading() {
    state = HttpState.loading();
  }

  void stopLoading() {
    state = HttpState.init();
  }

  Future<void> _fetchCounts() async {
    state = const HttpState.loading();

    try {
      final results = await Future.wait([
        _deliveriesRepository.getDeliveriesCount(DeliveriesCountTypeEnum.todo),
        _deliveriesRepository.getDeliveriesCount(
          DeliveriesCountTypeEnum.finished,
        ),
      ]);

      final todoResponse = results[0];
      final finishedResponse = results[1];

      if (todoResponse.isSucess || finishedResponse.isSucess) {
        state = HttpState.success(
          message: 'Comptes récupérés',
          data: {
            'pending': todoResponse.isSucess ? todoResponse.data : 0,
            'completed': finishedResponse.isSucess ? finishedResponse.data : 0,
          },
        );
        return;
      }

      state = HttpState.error(
        errorType: todoResponse.errorType ?? NetworkErrorType.server,
        message: 'Impossible de récupérer les comptes',
      );
    } catch (e) {
      state = HttpState.error(
        errorType: NetworkErrorType.server,
        message: 'Erreur inattendue',
      );
    }
  }

  Future<void> refetch() async {
    state = HttpState.loading();

    await _fetchCounts();
  }

  @override
  HttpState? build() {
    _fetchCounts();
    return const HttpState.loading();
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/client/data/client_repository_impl.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

part 'search_client_notifier.g.dart';

@riverpod
class SearchClientNotifier extends _$SearchClientNotifier {
  final ClientRepositoryImpl _clientRepository = ClientRepositoryImpl();

  Future<void> search(String name) async {
    if (name.trim().length < 2) {
      state = HttpState.init();
      return;
    }

    bool cancelled = false;
    ref.onDispose(() => cancelled = true);

    state = HttpState.loading();

    await Future.delayed(const Duration(milliseconds: 500));
    if (cancelled) return;

    final response = await _clientRepository.searchClientsByName(name);
    if (cancelled) return;

    if (response.isSucess) {
      state = HttpState.success(data: response.data);
      return;
    }

    state = HttpState.error(
      errorType: response.errorType ?? NetworkErrorType.server,
      message: response.message ?? 'Impossible de récupérer les clients',
    );
  }

  void clear() {
    state = HttpState.init();
  }

  @override
  HttpState build() => HttpState.init();
}

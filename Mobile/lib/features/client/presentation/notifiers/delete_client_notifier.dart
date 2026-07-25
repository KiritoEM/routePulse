import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/client/data/client_repository_impl.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

part 'delete_client_notifier.g.dart';

@riverpod
class DeleteClientNotifier extends _$DeleteClientNotifier {
  final _clientRepository = ClientRepositoryImpl();

  @override
  HttpState build() => const HttpState.init();

  Future<void> submit(String clientId) async {
    state = const HttpState.loading();

    final response = await _clientRepository.deleteClient(clientId);

    if (response.isSucess) {
      state = HttpState.success(message: response.message);
      return;
    }

    state = HttpState.error(
      errorType: response.errorType ?? NetworkErrorType.server,
      message: response.message ?? 'Impossible de supprimer le client',
    );
  }
}

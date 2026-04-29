import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/client/data/client_repository_impl.dart';
import 'package:route_pulse_mobile/features/client/domain/repositories/client_repository.dart';
import 'package:route_pulse_mobile/features/client/presentation/states/create_client_state.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

part 'delivery_create_client_notifier.g.dart';

@riverpod
class DeliveryCreateClientNotifier extends _$DeliveryCreateClientNotifier {
  late final ClientRepository _clientRepository = ClientRepositoryImpl();

  @override
  HttpState build() {
    return HttpState.init();
  }

  Future<void> createClient(CreateClientState clientData) async {
    state = HttpState.loading();

    final response = await _clientRepository.createClient(clientData, true);

    if (response.isSucess) {
      state = HttpState.success(data: response.data);
      return;
    }

    state = HttpState.error(
      errorType: response.errorType ?? NetworkErrorType.server,
      message: response.message ?? 'Impossible de créer le client',
    );
  }

  void reset() {
    state = HttpState.init();
  }
}

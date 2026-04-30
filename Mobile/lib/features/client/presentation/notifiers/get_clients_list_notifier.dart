import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/client/data/client_repository_impl.dart';
import 'package:route_pulse_mobile/features/client/domain/entities/client.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

part 'get_clients_list_notifier.g.dart';

@riverpod
class GetClientsListNotifier extends _$GetClientsListNotifier {
  final ClientRepositoryImpl _vehicleRepository = ClientRepositoryImpl();

  Future<void> _fetchClientsList() async {
    state = const HttpState.loading();

    final response = await _vehicleRepository.getAllClients();

    if (response.isSucess) {
      final clients = (response.data as List).cast<Client>();
      state = HttpState.success(data: clients);
      return;
    }
    state = HttpState.error(
      errorType: response.errorType ?? NetworkErrorType.server,
      message: response.message ?? 'Impossible de récupérer les clients',
    );
  }

  Future<void> refetch() async {
    state = HttpState.loading();

    await _fetchClientsList();
  }

  void startLoading() {
    state = HttpState.loading();
  }

  @override
  HttpState build() {
    _fetchClientsList();

    return const HttpState.loading();
  }
}

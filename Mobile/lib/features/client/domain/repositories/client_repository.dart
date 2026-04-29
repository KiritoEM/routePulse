import 'package:route_pulse_mobile/features/client/presentation/states/create_client_state.dart';
import 'package:route_pulse_mobile/shared/states/api_reponse.dart';

abstract class ClientRepository {
  Future<ApiResponse> searchClientsByName(String name);
  Future<ApiResponse> getAllClients();
  Future<ApiResponse> createClient(CreateClientState data, bool checkName);
}

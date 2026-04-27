import 'package:hive_ce/hive_ce.dart';
import 'package:route_pulse_mobile/core/local_db/models/client_model.dart';
import 'package:route_pulse_mobile/features/client/domain/entities/client.dart';

class ClientLocalDatasource {
  final Box<ClientHiveModel> _clientBox = Hive.box('clients');

  Future<ClientHiveModel?> saveNewClient(ClientHiveModel client) async {
    await _clientBox.put(client.id, client);

    return _clientBox.get(client.id);
  }

  List<Client> getClientByName(String name, String userId) {
    try {
      return _clientBox.values
          .where(
            (client) =>
                client.name.trim().toLowerCase().contains(
                  name.trim().toLowerCase(),
                ) &&
                client.userId == userId,
          )
          .map((client) => client.toEntity())
          .toList();
    } catch (_) {
      return List.empty();
    }
  }
}

import 'package:hive_ce/hive_ce.dart';
import 'package:route_pulse_mobile/core/local_db/models/client_model.dart';
import 'package:route_pulse_mobile/features/client/domain/entities/client.dart';
import 'package:route_pulse_mobile/features/client/presentation/states/update_client_state.dart';

class ClientLocalDatasource {
  final Box<ClientHiveModel> _clientBox = Hive.box('clients');

  Future<ClientHiveModel?> saveNewClient(ClientHiveModel client) async {
    await _clientBox.put(client.id, client);

    return _clientBox.get(client.id);
  }

  List<Client> getClientByName(String name, String userId) {
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
  }

  ClientHiveModel? getClientById(String id) {
    return _clientBox.get(id);
  }

  List<ClientHiveModel> getAllUnsyncedClients(String userId) {
    return _clientBox.values
        .where((client) => client.userId == userId && !client.isSynced)
        .toList();
  }

  Future<void> markAsSynced(String id) async {
    final client = _clientBox.get(id);
    if (client != null) {
      final updated = client.copyWith(
        isSynced: true,
        updatedAt: DateTime.now(),
      );
      await _clientBox.put(id, updated);
    }
  }

  List<Client> getAllClients(String userId) {
    return _clientBox.values
        .where((client) => client.userId == userId)
        .map((client) => client.toEntity())
        .toList();
  }

  List<Map<String, dynamic>> getAllClientsAsMap(String userId) {
    return _clientBox.values
        .where((client) => client.userId == userId)
        .map((client) => client.toMap())
        .toList();
  }

  Future<void> deleteClient(String id) async {
    await _clientBox.delete(id);
  }

  Future<ClientHiveModel?> updateClient(
    String id,
    UpdateClientState data,
  ) async {
    final existing = _clientBox.get(id);
    if (existing == null) return null;

    final updated = existing.copyWith(
      name: data.name ?? existing.name,
      phoneNumber: data.phoneNumber ?? existing.phoneNumber,
      address: data.address ?? existing.address,
      city: data.city ?? existing.city,
      location: data.location ?? existing.location,
      isSynced: false,
      updatedAt: DateTime.now(),
    );

    await _clientBox.put(id, updated);
    return _clientBox.get(id);
  }
}

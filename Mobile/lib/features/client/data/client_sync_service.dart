import 'package:route_pulse_mobile/core/local_db/models/client_model.dart';
import 'package:route_pulse_mobile/core/utils/app_logger.dart';
import 'package:route_pulse_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:route_pulse_mobile/features/client/data/datasources/client_local_datasource.dart';
import 'package:route_pulse_mobile/features/client/domain/entities/client.dart';
import 'package:route_pulse_mobile/features/client/domain/repositories/client_repository.dart';
import 'package:route_pulse_mobile/features/client/presentation/states/create_client_state.dart';
import 'package:route_pulse_mobile/shared/services/network_checking_service.dart';

class ClientSyncService {
  final ClientLocalDatasource _localDatasource;
  final ClientRepository _clientRepository;
  final AuthRepository _authRepository;

  ClientSyncService({
    required ClientLocalDatasource localDatasource,
    required ClientRepository clientRepository,
    required AuthRepository authRepository,
  }) : _localDatasource = localDatasource,
       _clientRepository = clientRepository,
       _authRepository = authRepository;

  Future<bool> sync() async {
    AppLogger.logger.i('Starting client sync...');

    try {
      final bool isOnline = await NetworkCheckingService.checkInternet();
      final currentUser = await _authRepository.getCurrentUser();
      final String? userId = currentUser.data['id'] as String?;

      if (userId == null) {
        AppLogger.logger.e('Sync aborted: current user id is null');
        return false;
      }

      if (!isOnline) {
        AppLogger.logger.w('Sync aborted: no internet connection');
        return false;
      }

      // Pull remote clients
      AppLogger.logger.i('Fetching remote clients...');
      final response = await _clientRepository.getAllClients();

      if (response.hasError == true) {
        AppLogger.logger.e(
          'Failed to fetch remote clients: ${response.message}',
        );
        return false;
      }

      final remoteClients = (response.data as List).cast<Client>();
      AppLogger.logger.i('Pulled ${remoteClients.length} remote clients');

      for (final remoteClient in remoteClients) {
        await _handlePullRemoteClient(remoteClient, userId);
      }

      AppLogger.logger.i('[PULLING] Client sync completed successfully');

      // Push local unsynced clients
      final unsyncedClients = _localDatasource.getAllUnsyncedClients(userId);
      AppLogger.logger.i(
        'Found ${unsyncedClients.length} unsynced local clients',
      );

      await _handlePushLocalClients(unsyncedClients, userId);

      AppLogger.logger.i('Client sync completed successfully');
      return true;
    } catch (err) {
      AppLogger.logger.e('An error occurred when syncing clients: $err');
      return false;
    }
  }

  Future<void> _handlePullRemoteClient(
    Client remoteClient,
    String userId,
  ) async {
    final isLocalExist =
        _localDatasource.getClientById(remoteClient.id) != null;

    if (!isLocalExist) {
      AppLogger.logger.d('Creating new local client: ${remoteClient.id}');
      await _localDatasource.saveNewClient(
        ClientHiveModel.fromEntity(remoteClient, userId),
      );
      return;
    }

    // Conflict: last-write-wins
    final localClient = _localDatasource.getClientById(remoteClient.id);
    if (localClient == null) return;

    if (remoteClient.updatedAt.isAfter(localClient.updatedAt)) {
      AppLogger.logger.d(
        'Remote client is newer, updating local: ${remoteClient.id}',
      );
      await _localDatasource.saveNewClient(
        ClientHiveModel.fromEntity(remoteClient, userId),
      );
      return;
    }

    AppLogger.logger.d(
      'Local client is newer, keeping local: ${remoteClient.id}',
    );
  }

  Future<void> _handlePushLocalClients(
    List<ClientHiveModel> unsyncedClients,
    String userId,
  ) async {
    for (final localClient in unsyncedClients) {
      AppLogger.logger.i('Pushing local client: ${localClient.id}');

      final pushResponse = await _clientRepository.createClient(
        CreateClientState.fromMap(localClient.toMap()),
        false,
      );

      if (pushResponse.isSucess) {
        final backendId = pushResponse.data['id'] as String;

        AppLogger.logger.i(
          '[PUSHING] Client pushed successfully, new backend id: $backendId',
        );

        // delete old local entry with local id
        await _localDatasource.deleteClient(localClient.id);

        AppLogger.logger.d('Deleted old local client: ${localClient.id}');

        final syncedHiveModel = ClientHiveModel.fromMap({
          ...localClient.toMap(),
          'id': backendId,
        }, userId).copyWith(isSynced: true, updatedAt: DateTime.now());

        await _localDatasource.saveNewClient(syncedHiveModel);

        AppLogger.logger.d('Saved synced client: $backendId');
      } else {
        AppLogger.logger.w('Failed to push local client: ${localClient.id}');
      }
    }
  }
}

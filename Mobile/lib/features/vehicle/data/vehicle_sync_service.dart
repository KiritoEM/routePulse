import 'package:route_pulse_mobile/core/local_db/models/vehicle_model.dart';
import 'package:route_pulse_mobile/core/utils/app_logger.dart';
import 'package:route_pulse_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:route_pulse_mobile/features/vehicle/data/datasources/vehicle_local_datasource.dart';
import 'package:route_pulse_mobile/features/vehicle/domain/entities/vehicle.dart';
import 'package:route_pulse_mobile/features/vehicle/domain/repositories/vehicle_repository.dart';
import 'package:route_pulse_mobile/features/vehicle/presentation/states/create_vehicle_state.dart';
import 'package:route_pulse_mobile/shared/services/network_checking_service.dart';

class VehicleSyncService {
  final VehicleLocalDatasource _localDatasource;
  final VehicleRepository _vehicleRepository;
  final AuthRepository _authRepository;

  VehicleSyncService({
    required VehicleLocalDatasource localDatasource,
    required VehicleRepository vehicleRepository,
    required AuthRepository authRepository,
  }) : _localDatasource = localDatasource,
       _vehicleRepository = vehicleRepository,
       _authRepository = authRepository;

  Future<bool> sync() async {
    AppLogger.logger.i('Starting Vehicle sync...');

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

      // Pull remote vehicles
      AppLogger.logger.i('Fetching remote clients...');
      final response = await _vehicleRepository.getAllVehicles();

      if (response.hasError == true) {
        AppLogger.logger.e(
          'Failed to fetch remote vehicles: ${response.message}',
        );
        return false;
      }

      final remoteVehicles = (response.data as List).cast<Vehicle>();
      AppLogger.logger.i('Pulled ${remoteVehicles.length} remote vehicles');

      for (final remoteVehicle in remoteVehicles) {
        await _handlePullRemoteVehicle(remoteVehicle, userId);
      }

      AppLogger.logger.i('[PULLING] Vehicles sync completed successfully');

      // Push local unsynced clients
      final unsyncedVehicles = _localDatasource.getAllUnsyncedVehicles(userId);
      AppLogger.logger.i(
        'Found ${unsyncedVehicles.length} unsynced local vehicles',
      );

      await _handlePushLocalVehicles(unsyncedVehicles, userId);
    } catch (err) {
      AppLogger.logger.e('An error occurred when syncing vehicles: $err');
      return false;
    }

    return true;
  }

  Future<void> _handlePullRemoteVehicle(
    Vehicle remoteVehicle,
    String userId,
  ) async {
    final isLocalExist =
        _localDatasource.getVehicleById(remoteVehicle.id) != null;

    if (!isLocalExist) {
      AppLogger.logger.d('Creating new local vehicle : ${remoteVehicle.id}');
      await _localDatasource.saveNewVehicle(
        VehicleHiveModel.fromEntity(remoteVehicle, userId),
      );
      return;
    }

    // Conflict: last-write-wins
    final localClient = _localDatasource.getVehicleById(remoteVehicle.id);
    if (localClient == null) return;

    if (remoteVehicle.updatedAt.isAfter(localClient.updatedAt)) {
      AppLogger.logger.d(
        'Remote vehicle is newer, updating local: ${remoteVehicle.id}',
      );
      await _localDatasource.saveNewVehicle(
        VehicleHiveModel.fromEntity(remoteVehicle, userId),
      );
      return;
    }

    AppLogger.logger.d(
      'Local vehicle is newer, keeping local: ${remoteVehicle.id}',
    );
  }

  Future<void> _handlePushLocalVehicles(
    List<VehicleHiveModel> unsyncedClients,
    String userId,
  ) async {
    for (final localVehicle in unsyncedClients) {
      AppLogger.logger.i('Pushing local Vehicle : ${localVehicle.id}');

      final pushResponse = await _vehicleRepository.createVehicle(
        CreateVehicleState.fromMap(localVehicle.toMap()),
      );

      if (pushResponse.isSucess) {
        final backendId = pushResponse.data['id'] as String;

        AppLogger.logger.i(
          '[PUSHING] Vehicle pushed successfully, new backend id: $backendId',
        );

        // delete old local entry with local id
        await _localDatasource.deleteVehicle(localVehicle.id);

        AppLogger.logger.d('Deleted old local vehicle: ${localVehicle.id}');

        final syncedHiveModel = VehicleHiveModel.fromMap({
          ...localVehicle.toMap(),
          'id': backendId,
        }, userId).copyWith(isSynced: true, updatedAt: DateTime.now());

        await _localDatasource.saveNewVehicle(syncedHiveModel);

        AppLogger.logger.d('Saved synced client: $backendId');
      } else {
        AppLogger.logger.w('Failed to push local client: ${localVehicle.id}');
      }
    }
  }
}

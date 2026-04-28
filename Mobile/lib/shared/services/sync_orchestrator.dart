import 'package:route_pulse_mobile/core/utils/app_logger.dart';
import 'package:route_pulse_mobile/features/auth/data/auth_repository_impl.dart';
import 'package:route_pulse_mobile/features/client/data/client_repository_impl.dart';
import 'package:route_pulse_mobile/features/client/data/client_sync_service.dart';
import 'package:route_pulse_mobile/features/client/data/datasources/client_local_datasource.dart';
import 'package:route_pulse_mobile/features/deliveries/data/datasources/deliveries_local_datasource.dart';
import 'package:route_pulse_mobile/features/deliveries/data/deliveries_repository_impl.dart';
import 'package:route_pulse_mobile/features/deliveries/data/delivery_sync_service.dart';
import 'package:route_pulse_mobile/features/vehicle/data/datasources/vehicle_local_datasource.dart';
import 'package:route_pulse_mobile/features/vehicle/data/vehicle_repository_impl.dart';
import 'package:route_pulse_mobile/features/vehicle/data/vehicle_sync_service.dart';

class SyncOrchestrator {
  final _authRepository = AuthRepositoryImpl();

  late final ClientSyncService _clientSyncService;
  late final VehicleSyncService _vehicleSyncService;
  late final DeliverySyncService _deliverySyncService;

  SyncOrchestrator() {
    _clientSyncService = ClientSyncService(
      localDatasource: ClientLocalDatasource(),
      clientRepository: ClientRepositoryImpl(),
      authRepository: _authRepository,
    );

    _vehicleSyncService = VehicleSyncService(
      localDatasource: VehicleLocalDatasource(),
      vehicleRepository: VehicleRepositoryImpl(),
      authRepository: _authRepository,
    );

    _deliverySyncService = DeliverySyncService(
      localDatasource: DeliveriesLocalDatasource(),
      deliveriesRepository: DeliveriesRepositoryImpl(),
      authRepository: _authRepository,
    );
  }

  Future<void> syncAll() async {
    AppLogger.logger.i('[SYNC ORCHESTRATOR] Starting full sync...');

    await _syncWithLabel('clients', _clientSyncService.sync);
    await _syncWithLabel('vehicles', _vehicleSyncService.sync);
    await _syncWithLabel('deliveries', _deliverySyncService.sync);

    AppLogger.logger.i('[SYNC ORCHESTRATOR] Full sync completed');

    return;
  }

  Future<bool> _syncWithLabel(
    String label,
    Future<bool> Function() syncFn,
  ) async {
    try {
      AppLogger.logger.i('[SYNC ORCHESTRATOR] Syncing $label...');
      final success = await syncFn();
      if (success) {
        AppLogger.logger.i('[SYNC ORCHESTRATOR] $label sync succeeded');
      } else {
        AppLogger.logger.w('[SYNC ORCHESTRATOR] $label sync failed or skipped');
      }
      return success;
    } catch (err) {
      AppLogger.logger.e('[SYNC ORCHESTRATOR] $label sync threw: $err');
      return false;
    }
  }
}

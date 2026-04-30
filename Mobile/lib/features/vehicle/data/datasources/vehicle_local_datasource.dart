import 'package:hive_ce/hive_ce.dart';
import 'package:route_pulse_mobile/core/local_db/models/vehicle_model.dart';
import 'package:route_pulse_mobile/features/vehicle/domain/entities/vehicle.dart';
import 'package:route_pulse_mobile/features/vehicle/presentation/states/update_vehicle_state.dart';

class VehicleLocalDatasource {
  final Box<VehicleHiveModel> _vehicleBox = Hive.box('vehicles');

  Future<VehicleHiveModel?> saveNewVehicle(VehicleHiveModel vehicle) async {
    await _vehicleBox.put(vehicle.id, vehicle);

    return _vehicleBox.get(vehicle.id);
  }

  Future<void> deleteVehicle(String id) async {
    await _vehicleBox.delete(id);
  }

  List<Vehicle> getAllVehicles(String userId) {
    return _vehicleBox.values
        .where((client) => client.userId == userId)
        .map((vehicle) => vehicle.toEntity())
        .toList();
  }

  List<VehicleHiveModel> getAllUnsyncedVehicles(String userId) {
    return _vehicleBox.values
        .where((vehicle) => vehicle.userId == userId && !vehicle.isSynced)
        .toList();
  }

  VehicleHiveModel? getVehicleById(String id) {
    return _vehicleBox.get(id);
  }

  Future<void> markAsSynced(String id) async {
    final vehicle = _vehicleBox.get(id);

    if (vehicle != null) {
      final updated = vehicle.copyWith(
        isSynced: true,
        updatedAt: DateTime.now(),
      );
      await _vehicleBox.put(id, updated);
    }
  }

  Future<VehicleHiveModel?> updateVehicle(
    String id,
    UpdateVehicleState data,
  ) async {
    final existing = _vehicleBox.get(id);
    if (existing == null) return null;

    final updated = existing.copyWith(
      name: data.name ?? existing.name,
      type: data.type ?? existing.type,
      plateNumber: data.plateNumber ?? existing.plateNumber,
      isSynced: false,
      updatedAt: DateTime.now(),
    );

    await _vehicleBox.put(id, updated);
    return _vehicleBox.get(id);
  }
}

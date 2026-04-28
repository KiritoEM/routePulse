import 'package:hive_ce/hive_ce.dart';
import 'package:route_pulse_mobile/core/local_db/models/vehicle_model.dart';
import 'package:route_pulse_mobile/features/vehicle/domain/entities/vehicle.dart';

class VehicleLocalDatasource {
  final Box<VehicleHiveModel> _vehicleBox = Hive.box('vehicles');

  Future<void> saveNewVehicle(VehicleHiveModel vehicle) async {
    await _vehicleBox.put(vehicle.id, vehicle);
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
}

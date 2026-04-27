import 'package:hive_ce/hive_ce.dart';
import 'package:route_pulse_mobile/core/local_db/models/vehicle_model.dart';
import 'package:route_pulse_mobile/features/vehicle/domain/entities/vehicle.dart';

class VehicleLocalDatasource {
  final Box<VehicleHiveModel> _vehicleBox = Hive.box('vehicles');

  List<Vehicle> getAllVehicles(String userId) {
    return _vehicleBox.values
        .where((client) => client.userId == userId)
        .map((vehicle) => vehicle.toEntity())
        .toList();
  }
}

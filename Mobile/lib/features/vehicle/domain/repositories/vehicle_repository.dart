import 'package:route_pulse_mobile/features/vehicle/presentation/states/create_vehicle_state.dart';
import 'package:route_pulse_mobile/shared/states/api_reponse.dart';

abstract class VehicleRepository {
  Future<ApiResponse> createVehicle(CreateVehicleState data);
  Future<ApiResponse> getAllVehicles();
}

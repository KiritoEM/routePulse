import 'package:route_pulse_mobile/shared/states/api_reponse.dart';

abstract class VehicleRepository {
  Future<ApiResponse> getAllVehicles();
}

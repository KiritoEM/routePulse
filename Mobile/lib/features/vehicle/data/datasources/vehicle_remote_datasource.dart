import 'package:route_pulse_mobile/core/constants/api_constant.dart';
import 'package:route_pulse_mobile/core/network/dio_config.dart';

class VehicleRemoteDatasource {
  final _dio = DioConfig.instance;

  Future<Map<String, dynamic>> getAllVehicles() async {
    final response = await _dio.get(ApiConstant.VEHICLE_ENDPOINT);

    return response.data;
  }
}

import 'package:route_pulse_mobile/core/constants/api_constant.dart';
import 'package:route_pulse_mobile/core/network/dio_config.dart';
import 'package:route_pulse_mobile/features/vehicle/presentation/states/create_vehicle_state.dart';
import 'package:route_pulse_mobile/features/vehicle/presentation/states/update_vehicle_state.dart';

class VehicleRemoteDatasource {
  final _dio = DioConfig.instance;

  Future<Map<String, dynamic>> getAllVehicles() async {
    final response = await _dio.get(ApiConstant.VEHICLE_ENDPOINT);

    return response.data;
  }

  Future<Map<String, dynamic>> createVehicle(CreateVehicleState data) async {
    final response = await _dio.post(
      ApiConstant.VEHICLE_ENDPOINT,
      data: data.toJson(),
    );

    return response.data;
  }

  Future<Map<String, dynamic>> updateVehicle(
    String id,
    UpdateVehicleState data,
  ) async {
    final response = await _dio.patch(
      '${ApiConstant.VEHICLE_ENDPOINT}/$id',
      data: data.toJson(),
    );

    return response.data;
  }
}

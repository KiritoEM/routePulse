import 'package:route_pulse_mobile/core/constants/api_constant.dart';
import 'package:route_pulse_mobile/core/network/dio_config.dart';
import 'package:route_pulse_mobile/features/client/presentation/states/create_client_state.dart';
import 'package:route_pulse_mobile/features/client/presentation/states/update_client_state.dart';

class ClientRemoteDatasource {
  final _dio = DioConfig.instance;

  Future<Map<String, dynamic>> searchClientsByName(String name) async {
    final response = await _dio.get(
      '${ApiConstant.CLIENT_ENDPOINT}/search',
      queryParameters: {'name': name},
    );

    return response.data;
  }

  Future<Map<String, dynamic>> getAllClients() async {
    final response = await _dio.get(ApiConstant.CLIENT_ENDPOINT);

    return response.data;
  }

  Future<Map<String, dynamic>> createClient(
    CreateClientState data,
    bool checkName,
  ) async {
    final response = await _dio.post(
      ApiConstant.CLIENT_ENDPOINT,
      data: {...data.toJson(), 'checkName': checkName},
    );

    return response.data;
  }

  Future<Map<String, dynamic>> updateClient(
    String id,
    UpdateClientState data,
  ) async {
    final response = await _dio.patch(
      '${ApiConstant.CLIENT_ENDPOINT}/$id',
      data: data,
    );

    return response.data;
  }
}

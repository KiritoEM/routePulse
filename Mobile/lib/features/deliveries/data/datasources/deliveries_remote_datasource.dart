import 'package:route_pulse_mobile/core/constants/api_constant.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/network/dio_config.dart';

class DeliveriesRemoteDatasource {
  final _dio = DioConfig.instance;

  Future<List<Map<String, dynamic>>> getAllDeliveries({
    DeliveryStatus? status,
  }) async {
    final response = await _dio.get(
      ApiConstant.DELIVERIES_ENDPOINT,
      queryParameters: {'status': status?.value.toUpperCase()},
    );

    return response.data['data'];
  }
}

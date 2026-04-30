import 'package:route_pulse_mobile/core/constants/api_constant.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/network/dio_config.dart';
import 'package:route_pulse_mobile/features/deliveries/data/models/create_delivery_dto.dart';

class DeliveriesRemoteDatasource {
  final _dio = DioConfig.instance;

  Future<Map<String, dynamic>> getAllDeliveries({
    DeliveryStatus? status,
    SortFilterEnum? sort,
  }) async {
    Map<String, dynamic> query = {};

    if (status != null) {
      query['status'] = status.value;
    }

    if (sort != null) {
      query['sort'] = sort.value.toUpperCase();
    }

    final response = await _dio.get(
      ApiConstant.DELIVERIES_ENDPOINT,
      queryParameters: query,
    );

    return response.data;
  }

  Future<Map<String, dynamic>> getDeliveryById(String id) async {
    final response = await _dio.get('${ApiConstant.DELIVERIES_ENDPOINT}/$id');

    return response.data;
  }

  Future<Map<String, dynamic>> getTodayPendingDeliveries() async {
    final response = await _dio.get(
      '${ApiConstant.DELIVERIES_ENDPOINT}/pending',
    );

    return response.data;
  }

  Future<Map<String, dynamic>> getDeliveriesCount(
    DeliveriesCountTypeEnum type,
  ) async {
    final response = await _dio.get(
      '${ApiConstant.DELIVERIES_ENDPOINT}/count/${type.value}',
    );

    return response.data;
  }

  Future<Map<String, dynamic>> createDelivery(CreateDeliveryDto data) async {
    final response = await _dio.post(
      ApiConstant.DELIVERIES_ENDPOINT,
      data: data.toJson(),
    );

    return response.data;
  }

  Future<Map<String, dynamic>> startDelivery(String deliveryId) async {
    final response = await _dio.patch(
      '${ApiConstant.DELIVERIES_ENDPOINT}/$deliveryId/start',
    );

    return response.data;
  }

  Future<Map<String, dynamic>> cancelDelivery(
    String deliveryId,
    String reason,
  ) async {
    final response = await _dio.patch(
      '${ApiConstant.DELIVERIES_ENDPOINT}/$deliveryId/cancel',
      data: {'reason': reason},
    );

    return response.data;
  }

  Future<Map<String, dynamic>> reportDelivery(
    String deliveryId,
    String newDate,
  ) async {
    final response = await _dio.patch(
      '${ApiConstant.DELIVERIES_ENDPOINT}/$deliveryId/report',
      data: {'newDate': newDate},
    );

    return response.data;
  }
}

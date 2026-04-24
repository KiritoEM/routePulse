import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/utils/app_logger.dart';
import 'package:route_pulse_mobile/core/utils/network_error_handler.dart';
// import 'package:route_pulse_mobile/features/deliveries/data/datasources/deliveries_local_datasource.dart';
import 'package:route_pulse_mobile/features/deliveries/data/datasources/deliveries_remote_datasource.dart';
import 'package:route_pulse_mobile/features/deliveries/data/models/deliveries_dto.dart';
import 'package:route_pulse_mobile/features/deliveries/domain/repositories/deliveries_repository.dart';
import 'package:route_pulse_mobile/shared/services/network_checking_service.dart';
import 'package:route_pulse_mobile/shared/states/api_reponse.dart';

class DeliveriesRepositoryImpl implements DeliveriesRepository {
  final DeliveriesRemoteDatasource _deliveriesRemoteDataSource =
      DeliveriesRemoteDatasource();
  // final DeliveriesLocalDatasource _deliveriesLocalDataSource =
  //     DeliveriesLocalDatasource();

  @override
  Future<ApiResponse> getAllDeliveries({DeliveryStatus? status, SortFilterEnum? sort}) async {
    final bool isOnline = await NetworkCheckingService.checkInternet();

    // if (!isOnline) {
    //   return _getAllDeliveriesOffline(status: status);
    // }

    try {
      final responseData = await _deliveriesRemoteDataSource
          .getAllDeliveries(status: status, sort: sort);

      final deliveries = responseData['data']
          .map((delivery) => DeliveryDto.fromJson(delivery).toEntity())
          .toList();

      return ApiResponse(
        message: 'Livraisons récupérées avec succès.',
        data: deliveries,
      );
    } on DioException catch (err) {
      AppLogger.logger.e(
        'DioException while fetching deliveries: ${err.response?.statusCode} - ${err.message} - ${err.error}',
      );

      // if (err.type == DioExceptionType.connectionTimeout ||
      //     err.type == DioExceptionType.sendTimeout ||
      //     err.type == DioExceptionType.receiveTimeout ||
      //     err.type == DioExceptionType.connectionError) {
      //   return _getAllDeliveriesOffline(status: status);
      // }

      return ApiResponse(
        hasError: true,
        message: NetworkErrorHandler.handleError(err)['message'],
        errorType:
            NetworkErrorHandler.handleError(err)['type'] as NetworkErrorType,
      );
    } catch (err) {
      AppLogger.logger.e('Error while fetching deliveries: $err');
      return ApiResponse(
        hasError: true,
        message: 'Impossible de récupérer les livraisons. Veuillez réessayer.',
        errorType: NetworkErrorType.server,
      );
    }
  }

  // Future<ApiResponse> _getAllDeliveriesOffline({DeliveryStatus? status}) async {
  //   try {
  //     final deliveries = _deliveriesLocalDataSource.getAllDeliveries(
  //       status: status,
  //     );
  //
  //     return ApiResponse(
  //       message: 'Livraisons récupérées localement.',
  //       data: deliveries,
  //     );
  //   } catch (err) {
  //     AppLogger.logger.e('Error while fetching deliveries offline: $err');
  //     return ApiResponse(
  //       hasError: true,
  //       message:
  //           'Impossible de récupérer les livraisons hors ligne. Veuillez réessayer.',
  //       errorType: NetworkErrorType.server,
  //     );
  //   }
  // }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/local_db/models/delivery_item_model.dart';
import 'package:route_pulse_mobile/core/local_db/models/delivery_model.dart';
import 'package:route_pulse_mobile/core/utils/app_logger.dart';
import 'package:route_pulse_mobile/core/utils/date_utils.dart';
import 'package:route_pulse_mobile/core/utils/network_error_handler.dart';
import 'package:route_pulse_mobile/core/utils/random_number_utils.dart';
import 'package:route_pulse_mobile/features/auth/data/auth_repository_impl.dart';
import 'package:route_pulse_mobile/features/deliveries/data/datasources/deliveries_local_datasource.dart';
import 'package:route_pulse_mobile/features/deliveries/data/datasources/deliveries_remote_datasource.dart';
import 'package:route_pulse_mobile/features/deliveries/data/models/create_delivery_dto.dart';
import 'package:route_pulse_mobile/features/deliveries/data/models/deliveries_dto.dart';
import 'package:route_pulse_mobile/features/deliveries/domain/repositories/deliveries_repository.dart';
import 'package:route_pulse_mobile/shared/services/network_checking_service.dart';
import 'package:route_pulse_mobile/shared/states/api_reponse.dart';
import 'package:uuid/uuid.dart';

class DeliveriesRepositoryImpl implements DeliveriesRepository {
  final DeliveriesRemoteDatasource _deliveriesRemoteDataSource =
      DeliveriesRemoteDatasource();
  final DeliveriesLocalDatasource _deliveriesLocalDataSource =
      DeliveriesLocalDatasource();
  final AuthRepositoryImpl _authRepository = AuthRepositoryImpl();
  var uuid = Uuid();

  @override
  Future<ApiResponse> getAllDeliveries({
    DeliveryStatus? status,
    SortFilterEnum? sort,
  }) async {
    final bool isOnline = await NetworkCheckingService.checkInternet();

    if (!isOnline) {
      return _getAllDeliveriesOffline(status: status, sort: sort);
    }

    try {
      final responseData = await _deliveriesRemoteDataSource.getAllDeliveries(
        status: status,
        sort: sort,
      );

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

      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout ||
          err.type == DioExceptionType.connectionError) {
        return _getAllDeliveriesOffline(status: status, sort: sort);
      }

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

  Future<ApiResponse> _getAllDeliveriesOffline({
    DeliveryStatus? status,
    SortFilterEnum? sort,
  }) async {
    try {
      final deliveries = _deliveriesLocalDataSource.getAllDeliveries(
        status: status,
        sort: sort,
      );

      return ApiResponse(
        message: 'Livraisons récupérées localement.',
        data: deliveries,
      );
    } catch (err) {
      AppLogger.logger.e('Error while fetching deliveries offline: $err');
      return ApiResponse(
        hasError: true,
        message:
            'Impossible de récupérer les livraisons hors ligne. Veuillez réessayer.',
        errorType: NetworkErrorType.server,
      );
    }
  }

  @override
  Future<ApiResponse> createDelivery(CreateDeliveryDto data) async {
    final bool isOnline = await NetworkCheckingService.checkInternet();
    final currentUser = await _authRepository.getCurrentUser();
    final String userId = currentUser.data['id'];

    if (!isOnline) {
      return _createLocalDelivery(data, userId);
    }

    try {
      final responseData = await _deliveriesRemoteDataSource.createDelivery(
        data,
      );

      // add delivery to local DB
      final localDeliveryData = DeliveryHiveModel.fromMap({
        ...data.toMap()..remove('articles'),
        'id': responseData['data']['id'],
        'deliveryId': responseData['data']['deliveryId'],
      }, userId);

      final localArticlesData = data.articles
          .map((item) => DeliveryHiveModel.fromMap(item.toMap(), userId))
          .whereType<DeliveryItemHiveModel>()
          .toList();

      await _deliveriesLocalDataSource.saveNewDelivery(
        delivery: localDeliveryData,
        articles: localArticlesData,
      );
      await _deliveriesLocalDataSource.markAsSynced(localDeliveryData.id);

      return ApiResponse(
        message: responseData['message'],
        data: responseData['data'],
      );
    } on DioException catch (err) {
      AppLogger.logger.e(
        'DioException while creating delivery: ${err.response?.statusCode} - ${err.message} - ${err.error}',
      );

      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout ||
          err.type == DioExceptionType.connectionError) {
        return _createLocalDelivery(data, userId);
      }

      return ApiResponse(
        hasError: true,
        message: NetworkErrorHandler.handleError(err)['message'],
        errorType:
            NetworkErrorHandler.handleError(err)['type'] as NetworkErrorType,
      );
    } catch (err) {
      AppLogger.logger.e('Error while creating delivery: $err');
      return ApiResponse(
        hasError: true,
        message: 'Impossible de créer la livraison. Veuillez réessayer.',
        errorType: NetworkErrorType.server,
      );
    }
  }

  Future<ApiResponse> _createLocalDelivery(
    CreateDeliveryDto data,
    String userId,
  ) async {
    try {
      final String datePart = CustomDateUtils.formatDate(
        DateTime.now(),
      ).toString().split('/').reversed.toList().join('');
      final String deliveryId =
          'RP-$datePart-${RandomNumberUtils.generateRandomNumber().toString()}';

      final localDeliveryData = DeliveryHiveModel.fromMap({
        ...data.toMap()..remove('articles'),
        'id': uuid.v4(),
        'deliveryId': deliveryId,
      }, userId);

      final localArticlesData = data.articles
          .map((item) => DeliveryHiveModel.fromMap(item.toMap(), userId))
          .whereType<DeliveryItemHiveModel>()
          .toList();

      await _deliveriesLocalDataSource.saveNewDelivery(
        delivery: localDeliveryData,
        articles: localArticlesData,
      );

      return ApiResponse(message: 'Livraison créée avec succés');
    } catch (err) {
      AppLogger.logger.e('Error while creating local delivery: $err');
      return ApiResponse(
        hasError: true,
        message: 'Impossible de créer la livraison. Veuillez réessayer.',
        errorType: NetworkErrorType.server,
      );
    }
  }
}

import 'package:dio/dio.dart';
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
import 'package:route_pulse_mobile/features/deliveries/domain/entities/delivery.dart';
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
  Future<ApiResponse<List<Delivery>>> getAllDeliveries({
    DeliveryStatus? status,
    SortFilterEnum? sort,
  }) async {
    final bool isOnline = await NetworkCheckingService.checkInternet();
    final currentUser = await _authRepository.getCurrentUser();
    final String? userId = currentUser.data?['id'];

    if (userId == null) {
      return ApiResponse(
        hasError: true,
        message: 'Session expirée. Veuillez vous reconnecter.',
        errorType: NetworkErrorType.server,
      );
    }

    if (!isOnline) {
      return _getAllLocalDeliveries(status: status, sort: sort, userId: userId);
    }

    try {
      final responseData = await _deliveriesRemoteDataSource.getAllDeliveries(
        status: status,
        sort: sort,
      );

      final deliveries = responseData['data']
          .map((delivery) => DeliveryDto.fromJson(delivery).toEntity())
          .toList()
          .cast<Delivery>();

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
        return _getAllLocalDeliveries(
          status: status,
          sort: sort,
          userId: userId,
        );
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

  Future<ApiResponse<List<Delivery>>> _getAllLocalDeliveries({
    DeliveryStatus? status,
    SortFilterEnum? sort,
    required String userId,
  }) async {
    try {
      final deliveries = _deliveriesLocalDataSource.getAllDeliveries(
        status: status,
        sort: sort,
        userId: userId,
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
  Future<ApiResponse<int>> getDeliveriesCount(
    DeliveriesCountTypeEnum type,
  ) async {
    final bool isOnline = await NetworkCheckingService.checkInternet();
    final currentUser = await _authRepository.getCurrentUser();
    final String? userId = currentUser.data?['id'];

    if (userId == null) {
      return ApiResponse(
        hasError: true,
        message: 'Session expirée. Veuillez vous reconnecter.',
        errorType: NetworkErrorType.server,
      );
    }

    if (!isOnline) {
      return _getLocalDeliveriesCount(type, userId);
    }

    try {
      final responseData = await _deliveriesRemoteDataSource.getDeliveriesCount(
        type,
      );

      final count = responseData['data'] as int? ?? 0;

      return ApiResponse(
        message:
            responseData['message'] ??
            'Nombre de livraisons récupéré avec succès.',
        data: count,
      );
    } on DioException catch (err) {
      AppLogger.logger.e(
        'DioException while fetching deliveries count: ${err.response?.statusCode} - ${err.message}',
      );

      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout ||
          err.type == DioExceptionType.connectionError) {
        return _getLocalDeliveriesCount(type, userId);
      }

      return ApiResponse(
        hasError: true,
        message: NetworkErrorHandler.handleError(err)['message'],
        errorType:
            NetworkErrorHandler.handleError(err)['type'] as NetworkErrorType,
      );
    } catch (err) {
      AppLogger.logger.e('Error while fetching deliveries count: $err');
      return ApiResponse(
        hasError: true,
        message:
            'Impossible de récupérer le nombre de livraisons. Veuillez réessayer.',
        errorType: NetworkErrorType.server,
      );
    }
  }

  Future<ApiResponse<int>> _getLocalDeliveriesCount(
    DeliveriesCountTypeEnum type,
    String userId,
  ) async {
    try {
      final todayDate = CustomDateUtils.getTodayDateFormatted();
      final count = _deliveriesLocalDataSource.getDeliveriesCount(
        type: type,
        userId: userId,
        deliveryDate: todayDate,
      );

      return ApiResponse(
        message: 'Nombre de livraisons récupéré localement.',
        data: count,
      );
    } catch (err) {
      AppLogger.logger.e('Error while fetching local deliveries count: $err');
      return ApiResponse(
        hasError: true,
        message: 'Impossible de récupérer le nombre de livraisons hors ligne.',
        errorType: NetworkErrorType.server,
      );
    }
  }

  @override
  Future<ApiResponse<List<Delivery>>> getTodayPendingDeliveries() async {
    final bool isOnline = await NetworkCheckingService.checkInternet();
    final currentUser = await _authRepository.getCurrentUser();
    final String? userId = currentUser.data?['id'];

    if (userId == null) {
      return ApiResponse(
        hasError: true,
        message: 'Session expirée. Veuillez vous reconnecter.',
        errorType: NetworkErrorType.server,
      );
    }

    if (!isOnline) {
      return _getLocalTodayPendingDeliveries(userId);
    }

    try {
      final responseData = await _deliveriesRemoteDataSource
          .getTodayPendingDeliveries();

      final deliveries = (responseData['data'] as List)
          .map((delivery) => DeliveryDto.fromJson(delivery).toEntity())
          .toList()
          .cast<Delivery>();

      return ApiResponse(
        message:
            responseData['message'] ??
            'Livraisons du jour récupérées avec succès.',
        data: deliveries,
      );
    } on DioException catch (err) {
      AppLogger.logger.e(
        'DioException while fetching today pending deliveries: ${err.response?.statusCode}',
      );

      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout ||
          err.type == DioExceptionType.connectionError) {
        return _getLocalTodayPendingDeliveries(userId);
      }

      return ApiResponse(
        hasError: true,
        message: NetworkErrorHandler.handleError(err)['message'],
        errorType:
            NetworkErrorHandler.handleError(err)['type'] as NetworkErrorType,
      );
    } catch (err) {
      AppLogger.logger.e('Error while fetching today pending deliveries: $err');
      return _getLocalTodayPendingDeliveries(userId);
    }
  }

  Future<ApiResponse<List<Delivery>>> _getLocalTodayPendingDeliveries(
    String userId,
  ) async {
    try {
      final todayDate = CustomDateUtils.getTodayDateFormatted();
      final deliveries = _deliveriesLocalDataSource.getTodayPendingDeliveries(
        userId: userId,
        deliveryDate: todayDate,
      );

      return ApiResponse(
        message: 'Livraisons du jour récupérées localement.',
        data: deliveries,
      );
    } catch (err) {
      AppLogger.logger.e(
        'Error while fetching local today pending deliveries: $err',
      );
      return ApiResponse(
        hasError: true,
        message: 'Impossible de récupérer les livraisons du jour hors ligne.',
        errorType: NetworkErrorType.server,
      );
    }
  }

  @override
  Future<ApiResponse<Delivery?>> getDeliveryById(String id) async {
    final bool isOnline = await NetworkCheckingService.checkInternet();

    if (!isOnline) {
      return _getLocalDelivery(id);
    }

    try {
      final responseData = await _deliveriesRemoteDataSource.getDeliveryById(
        id,
      );

      final delivery = DeliveryDto.fromJson(responseData['data']).toEntity();

      return ApiResponse(
        message: 'Livraison récupérée avec succès.',
        data: delivery,
      );
    } on DioException catch (err) {
      AppLogger.logger.e(
        'DioException while fetching delivery: ${err.response?.statusCode} - ${err.message} - ${err.error}',
      );

      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout ||
          err.type == DioExceptionType.connectionError) {
        return _getLocalDelivery(id);
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
        message: 'Impossible de récupérer la livraison. Veuillez réessayer.',
        errorType: NetworkErrorType.server,
      );
    }
  }

  Future<ApiResponse<Delivery?>> _getLocalDelivery(String id) async {
    try {
      final deliveries = _deliveriesLocalDataSource.getDeliveryById(id);

      return ApiResponse(
        message: 'Livraison récupérée localement.',
        data: deliveries,
      );
    } catch (err) {
      AppLogger.logger.e('Error while fetching delivery offline: $err');
      return ApiResponse(
        hasError: true,
        message:
            'Impossible de récupérer la livraison en hors ligne. Veuillez réessayer.',
        errorType: NetworkErrorType.server,
      );
    }
  }

  @override
  Future<ApiResponse> createDelivery(CreateDeliveryDto data) async {
    final bool isOnline = await NetworkCheckingService.checkInternet();
    final currentUser = await _authRepository.getCurrentUser();
    final String? userId = currentUser.data?['id'];

    if (userId == null) {
      return ApiResponse(
        hasError: true,
        message: 'Session expirée. Veuillez vous reconnecter.',
        errorType: NetworkErrorType.server,
      );
    }

    if (!isOnline) {
      return _createLocalDelivery(data, userId);
    }

    try {
      final responseData = await _deliveriesRemoteDataSource.createDelivery(
        data,
      );

      final String serverDeliveryId = responseData['data']['id'];

      // add delivery to local DB
      final localDeliveryData = DeliveryHiveModel.fromMap({
        ...data.toMap()..remove('articles'),
        'id': serverDeliveryId,
        'deliveryId': responseData['data']['deliveryId'],
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      }, userId);

      final localArticlesData = data.articles
          .map((item) {
            final map = item.toMap();
            map['deliveryId'] = serverDeliveryId;
            map['id'] = uuid.v4();
            map['createdAt'] = DateTime.now().toIso8601String();
            map['updatedAt'] = DateTime.now().toIso8601String();

            return DeliveryItemHiveModel.fromMap(map);
          })
          .whereType<DeliveryItemHiveModel>()
          .toList();
      AppLogger.logger.i(data.articles);

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
      final String localId = uuid.v4();
      final String datePart = CustomDateUtils.formatDate(
        DateTime.now(),
      ).toString().split('/').reversed.toList().join('');
      final String deliveryId =
          'RP-$datePart-${RandomNumberUtils.generateRandomNumber().toString()}';

      final localDeliveryData = DeliveryHiveModel.fromMap({
        ...data.toMap()..remove('articles'),
        'id': localId,
        'deliveryId': deliveryId,
      }, userId);

      final localArticlesData = data.articles
          .map((item) {
            final map = item.toMap();
            map['deliveryId'] = localId;
            return DeliveryItemHiveModel.fromMap(map);
          })
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

  @override
  Future<ApiResponse> startDelivery(String deliveryId) async {
    final bool isOnline = await NetworkCheckingService.checkInternet();

    if (!isOnline) {
      return _startLocalDelivery(deliveryId);
    }

    try {
      final responseData = await _deliveriesRemoteDataSource.startDelivery(
        deliveryId,
      );

      await _deliveriesLocalDataSource.updateDelivery(
        deliveryId,
        status: DeliveryStatus.inProgress.value,
      );

      return ApiResponse(message: responseData['message']);
    } on DioException catch (err) {
      AppLogger.logger.e(
        'DioException while starting delivery: ${err.response?.statusCode} - ${err.message}',
      );

      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout ||
          err.type == DioExceptionType.connectionError) {
        return _startLocalDelivery(deliveryId);
      }

      return ApiResponse(
        hasError: true,
        message: NetworkErrorHandler.handleError(err)['message'],
        errorType:
            NetworkErrorHandler.handleError(err)['type'] as NetworkErrorType,
      );
    } catch (err) {
      AppLogger.logger.e('Error while starting delivery: $err');
      return ApiResponse(
        hasError: true,
        message: 'Impossible de démarrer la livraison. Veuillez réessayer.',
        errorType: NetworkErrorType.server,
      );
    }
  }

  Future<ApiResponse> _startLocalDelivery(String deliveryId) async {
    try {
      await _deliveriesLocalDataSource.updateDelivery(
        deliveryId,
        status: DeliveryStatus.inProgress.value,
      );

      return ApiResponse(message: 'Livraison démarrée localement.');
    } catch (err) {
      AppLogger.logger.e('Error while starting local delivery: $err');
      return ApiResponse(
        hasError: true,
        message: 'Impossible de démarrer la livraison. Veuillez réessayer.',
        errorType: NetworkErrorType.server,
      );
    }
  }

  @override
  Future<ApiResponse> cancelDelivery(String deliveryId, String reason) async {
    final bool isOnline = await NetworkCheckingService.checkInternet();

    if (!isOnline) {
      return _cancelLocalDelivery(deliveryId, reason);
    }

    try {
      final responseData = await _deliveriesRemoteDataSource.cancelDelivery(
        deliveryId,
        reason,
      );

      await _deliveriesLocalDataSource.updateDelivery(
        deliveryId,
        status: DeliveryStatus.cancelled.value,
        cancelReason: reason,
      );

      return ApiResponse(message: responseData['message']);
    } on DioException catch (err) {
      AppLogger.logger.e(
        'DioException while cancelling delivery: ${err.response?.statusCode} - ${err.message}',
      );

      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout ||
          err.type == DioExceptionType.connectionError) {
        return _cancelLocalDelivery(deliveryId, reason);
      }

      return ApiResponse(
        hasError: true,
        message: NetworkErrorHandler.handleError(err)['message'],
        errorType:
            NetworkErrorHandler.handleError(err)['type'] as NetworkErrorType,
      );
    } catch (err) {
      AppLogger.logger.e('Error while cancelling delivery: $err');
      return ApiResponse(
        hasError: true,
        message: 'Impossible d\'annuler la livraison. Veuillez réessayer.',
        errorType: NetworkErrorType.server,
      );
    }
  }

  Future<ApiResponse> _cancelLocalDelivery(
    String deliveryId,
    String cancelReason,
  ) async {
    try {
      await _deliveriesLocalDataSource.updateDelivery(
        deliveryId,
        status: DeliveryStatus.cancelled.value,
        cancelReason: cancelReason,
      );
      return ApiResponse(message: 'Livraison annulée localement.');
    } catch (err) {
      AppLogger.logger.e('Error while cancelling local delivery: $err');
      return ApiResponse(
        hasError: true,
        message: 'Impossible d\'annuler la livraison. Veuillez réessayer.',
        errorType: NetworkErrorType.server,
      );
    }
  }

  @override
  Future<ApiResponse> reportDelivery(String deliveryId, String newDate) async {
    final bool isOnline = await NetworkCheckingService.checkInternet();

    if (!isOnline) {
      return _reportLocalDelivery(deliveryId, newDate);
    }

    try {
      final responseData = await _deliveriesRemoteDataSource.reportDelivery(
        deliveryId,
        newDate,
      );

      await _deliveriesLocalDataSource.updateDelivery(
        deliveryId,
        status: DeliveryStatus.reported.value,
        deliveryDate: newDate,
      );

      return ApiResponse(message: responseData['message']);
    } on DioException catch (err) {
      AppLogger.logger.e(
        'DioException while reporting delivery: ${err.response?.statusCode} - ${err.message}',
      );

      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout ||
          err.type == DioExceptionType.connectionError) {
        return _reportLocalDelivery(deliveryId, newDate);
      }

      return ApiResponse(
        hasError: true,
        message: NetworkErrorHandler.handleError(err)['message'],
        errorType:
            NetworkErrorHandler.handleError(err)['type'] as NetworkErrorType,
      );
    } catch (err) {
      AppLogger.logger.e('Error while reporting delivery: $err');
      return ApiResponse(
        hasError: true,
        message: 'Impossible de reporter la livraison. Veuillez réessayer.',
        errorType: NetworkErrorType.server,
      );
    }
  }

  Future<ApiResponse> _reportLocalDelivery(
    String deliveryId,
    String newDate,
  ) async {
    try {
      await _deliveriesLocalDataSource.updateDelivery(
        deliveryId,
        status: DeliveryStatus.reported.value,
        deliveryDate: newDate,
      );
      return ApiResponse(message: 'Livraison reportée localement.');
    } catch (err) {
      AppLogger.logger.e('Error while reporting local delivery: $err');
      return ApiResponse(
        hasError: true,
        message: 'Impossible de reporter la livraison. Veuillez réessayer.',
        errorType: NetworkErrorType.server,
      );
    }
  }
}

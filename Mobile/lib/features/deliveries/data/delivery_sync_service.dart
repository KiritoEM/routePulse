import 'package:route_pulse_mobile/core/local_db/models/delivery_item_model.dart';
import 'package:route_pulse_mobile/core/local_db/models/delivery_model.dart';
import 'package:route_pulse_mobile/core/utils/app_logger.dart';
import 'package:route_pulse_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:route_pulse_mobile/features/deliveries/data/datasources/deliveries_local_datasource.dart';
import 'package:route_pulse_mobile/features/deliveries/data/models/create_delivery_dto.dart';
import 'package:route_pulse_mobile/features/deliveries/domain/entities/delivery.dart';
import 'package:route_pulse_mobile/features/deliveries/domain/repositories/deliveries_repository.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/states/create_delivery_state.dart';
import 'package:route_pulse_mobile/shared/services/network_checking_service.dart';

class DeliverySyncService {
  final DeliveriesLocalDatasource _localDatasource;
  final DeliveriesRepository _deliveriesRepository;
  final AuthRepository _authRepository;

  DeliverySyncService({
    required DeliveriesLocalDatasource localDatasource,
    required DeliveriesRepository deliveriesRepository,
    required AuthRepository authRepository,
  }) : _localDatasource = localDatasource,
       _deliveriesRepository = deliveriesRepository,
       _authRepository = authRepository;

  Future<bool> sync() async {
    AppLogger.logger.i('Starting delivery sync...');

    try {
      final bool isOnline = await NetworkCheckingService.checkInternet();
      final currentUser = await _authRepository.getCurrentUser();
      final String userId = currentUser.data['id'];

      if (!isOnline) {
        AppLogger.logger.w('Sync aborted: no internet connection');
        return false;
      }

      // Pull data from the remote datasource and resolve conflict
      AppLogger.logger.i('Fetching remote deliveries...');
      final response = await _deliveriesRepository.getAllDeliveries();

      if (response.hasError == true) {
        AppLogger.logger.e(
          'Failed to fetch remote deliveries: ${response.message}',
        );
        return false;
      }

      final remoteDeliveries = response.data.cast<Delivery>();
      AppLogger.logger.i('Pulled ${remoteDeliveries.length} remote deliveries');

      for (final remoteDeliv in remoteDeliveries) {
        await _handlePullRemoteDeliveries(remoteDeliv, userId);

        AppLogger.logger.i('[PULLING] Sync completed successfully');
      }

      // Push local unsynced data
      final unsyncedDelivery = _localDatasource.getAllUnsyncedDeliveries();

      await _handlePushLocalDeliveries(unsyncedDelivery, userId);
      return true;
    } catch (err) {
      AppLogger.logger.e('An error was occured when syncing data: $err');
      return false;
    }
  }

  CreateDeliveryDto _deliveryToCreateDto(
    Delivery delivery, {
    String? existingId,
    String? existingDeliveryId,
  }) {
    return CreateDeliveryDto(
      clientId: delivery.clientId,
      address: delivery.address,
      city: delivery.city ?? 'Antananarivo',
      location: delivery.location,
      deliveryDate: delivery.deliveryDate?.toIso8601String(),
      timeSlotStart: delivery.timeSlotStart,
      timeSlotEnd: delivery.timeSlotEnd,
      vehicleId: delivery.vehicleId,
      articles:
          delivery.articles
              ?.map(
                (item) => DeliveryArticle(
                  name: item.name,
                  quantity: item.quantity,
                  price: item.price ?? 0.0,
                  file: item.image != null
                      ? ArticleFile(
                          file: item.image!.file,
                          originalName: item.image!.originalName,
                          mimeType: item.image!.mimeType,
                          size: item.image!.size,
                        )
                      : null,
                ),
              )
              .toList() ??
          [],
      notes: delivery.notes,
      checkIsExist: existingId != null,
      existingId: existingId,
      existingDeliveryId: existingDeliveryId ?? delivery.deliveryId,
    );
  }

  Future<void> _handlePushLocalDeliveries(
    List<Delivery> unsyncedDelivery,
    String userId,
  ) async {
    for (final localDeliv in unsyncedDelivery) {
      AppLogger.logger.i('Pushing local delivery: ${localDeliv.id}');

      final dto = _deliveryToCreateDto(localDeliv);

      final pushResponse = await _deliveriesRepository.createDelivery(dto);

      if (pushResponse.isSucess) {
        final backendId = pushResponse.data['id'] as String;
        final backendDeliveryId = pushResponse.data['deliveryId'] as String;

        AppLogger.logger.i(
          '[PUSHING] Delivery pushed successfully, new backend id: $backendId',
        );

        // delete old local entry with local id
        await _localDatasource.deleteDelivery(localDeliv.id);

        AppLogger.logger.d('Deleted old local delivery: ${localDeliv.id}');

        final syncedHiveModel = DeliveryHiveModel.fromMap({
          ...localDeliv.toCustomMap(),
          'id': backendId,
          'deliveryId': backendDeliveryId,
        }, userId).copyWith(isSynced: true, updatedAt: DateTime.now());

        final articlesData = localDeliv.articles
            .map((item) => DeliveryHiveModel.fromMap(item.toMap(), userId))
            .whereType<DeliveryItemHiveModel>()
            .toList();

        // save new entry
        await _localDatasource.saveNewDelivery(
          delivery: syncedHiveModel,
          articles: articlesData,
        );

        AppLogger.logger.d('Saved synced delivery with backend id: $backendId');
        return;
      }

      AppLogger.logger.w('Failed to push local delivery: ${localDeliv.id}');
    }
  }

  Future<void> _handlePullRemoteDeliveries(
    Delivery remoteDeliv,
    String userId,
  ) async {
    final isLocalExist = _localDatasource.checkIfIdExist(remoteDeliv.id);

    // Create new delivery in local if not exist
    if (!isLocalExist) {
      await _localDatasource.saveNewDelivery(
        delivery: DeliveryHiveModel.fromMap(remoteDeliv.toCustomMap(), userId),
      );
      return;
    }

    // Conflit: last-write-wins
    final localDeliv = _localDatasource.getDeliveryById(remoteDeliv.id);
    if (localDeliv == null) return;

    // if REMOTE win
    if (remoteDeliv.updatedAt.isAfter(localDeliv.updatedAt)) {
      final hiveModel = DeliveryHiveModel.fromMap(
        remoteDeliv.toCustomMap(),
        userId,
      );
      await _localDatasource.updateDelivery(hiveModel);

      return;
    }
  }
}

import 'package:hive_ce/hive_ce.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/local_db/models/delivery_item_model.dart';
import 'package:route_pulse_mobile/core/local_db/models/delivery_model.dart';
import 'package:route_pulse_mobile/core/utils/date_utils.dart';
import 'package:route_pulse_mobile/features/client/data/datasources/client_local_datasource.dart';
import 'package:route_pulse_mobile/features/deliveries/data/models/deliveries_dto.dart';
import 'package:route_pulse_mobile/features/deliveries/domain/entities/delivery.dart';

class DeliveriesLocalDatasource {
  final ClientLocalDatasource _clientLocalDataSource = ClientLocalDatasource();

  final Box<DeliveryHiveModel> _deliveryBox = Hive.box('deliveries');
  final Box<DeliveryItemHiveModel> _deliveryItemsBox = Hive.box(
    'delivery_items',
  );

  Future<void> saveNewDelivery({
    required DeliveryHiveModel delivery,
    List<DeliveryItemHiveModel>? articles,
  }) async {
    await _deliveryBox.put(delivery.id, delivery);
    if (articles == null) return;
    for (final item in articles) {
      await _deliveryItemsBox.put(item.id, item);
    }
  }

  Future<void> deleteDelivery(String id) async {
    // delete deliveryItems linked to this delivery
    final linkedItemKeys = _deliveryItemsBox.values
        .where((item) => item.deliveryId == id)
        .map((item) => item.id)
        .toList();

    await _deliveryItemsBox.deleteAll(linkedItemKeys);

    await _deliveryBox.delete(id);
  }

  // put delivery
  Future<void> putDelivery(DeliveryHiveModel delivery) async {
    await _deliveryBox.put(delivery.id, delivery);
  }

  // patch delivery
  Future<void> updateDelivery(
    String id, {
    String? status,
    String? deliveryDate,
    String? cancelReason,
  }) async {
    final delivery = _deliveryBox.get(id);

    if (delivery != null) {
      final updated = delivery.copyWith(
        status: status,
        isSynced: true,
        updatedAt: DateTime.now(),
      );

      await _deliveryBox.put(id, updated);
    }
  }

  bool checkIfIdExist(String id) {
    return _deliveryBox.containsKey(id);
  }

  List<Delivery> getAllDeliveries({
    required String userId,
    DeliveryStatus? status,
    SortFilterEnum? sort,
  }) {
    List<Delivery> allDeliveries = _deliveryBox.keys
        .map((id) => _getDeliveryWithArticles(id as String))
        .whereType<Delivery>()
        .where((d) => d.userId == userId)
        .toList();

    if (status != null) {
      allDeliveries = allDeliveries.where((d) => d.status == status).toList();
    }

    if (sort != null) {
      allDeliveries.sort((a, b) => _compareDeliveries(a, b, sort));
    } else {
      allDeliveries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return allDeliveries;
  }

  List<Delivery> getTodayPendingDeliveries({
    required String userId,
    required String deliveryDate,
  }) {
    List<Delivery> deliveries = _deliveryBox.keys
        .map((id) => _getDeliveryWithArticles(id as String))
        .whereType<Delivery>()
        .where(
          (d) =>
              d.userId == userId &&
              CustomDateUtils.formatBackendDate(d.deliveryDate) ==
                  deliveryDate &&
              d.status.value == DeliveryStatus.pending.value,
        )
        .toList();

    return deliveries;
  }

  int getDeliveriesCount({
    required DeliveriesCountTypeEnum type,
    required String userId,
    required String deliveryDate,
  }) {
    final List<DeliveryHiveModel> deliveries = _deliveryBox.values
        .where((d) => d.userId == userId && d.deliveryDate == deliveryDate)
        .toList();

    if (type.value == DeliveriesCountTypeEnum.todo.value) {
      return deliveries.where((d) => d.status == "pending").length;
    } else {
      return deliveries.where((d) => d.status == "delivered").length;
    }
  }

  Delivery? getDeliveryById(String id) {
    return _getDeliveryWithArticles(id);
  }

  List<Delivery> getAllUnsyncedDeliveries() {
    return _deliveryBox.values
        .where((d) => !d.isSynced)
        .map((d) => _getDeliveryWithArticles(d.id))
        .whereType<Delivery>()
        .toList();
  }

  Future<void> markAsSynced(String id) async {
    final delivery = _deliveryBox.get(id);
    if (delivery != null) {
      final updated = delivery.copyWith(
        isSynced: true,
        updatedAt: DateTime.now(),
      );
      await _deliveryBox.put(id, updated);
    }
  }

  Delivery? _getDeliveryWithArticles(String id) {
    final hiveDelivery = _deliveryBox.get(id);
    if (hiveDelivery == null) return null;

    final client = _clientLocalDataSource.getClientById(hiveDelivery.clientId);

    final articles = _getArticlesForDelivery(id);

    return DeliveryDto.fromJson({
      ...hiveDelivery.toMap(),
      'client': client?.toMap(),
      'articles': articles
          .map(
            (article) => {
              'id': article['id'],
              'deliveryId': article['deliveryId'],
              'name': article['name'],
              'quantity': article['quantity'],
              'price': article['price'],
            },
          )
          .toList(),
    }).toEntity();
  }

  List<Map<String, dynamic>> _getArticlesForDelivery(String deliveryId) {
    return _deliveryItemsBox.values
        .where((item) => item.deliveryId == deliveryId)
        .map((i) => i.toMap())
        .toList();
  }

  int _compareDeliveries(Delivery a, Delivery b, SortFilterEnum sort) {
    switch (sort) {
      case SortFilterEnum.timeSlot:
        return _timeToMinutes(
          a.timeSlotStart,
        ).compareTo(_timeToMinutes(b.timeSlotStart));
      case SortFilterEnum.creationDate:
        return b.createdAt.compareTo(a.createdAt);
    }
  }

  int _timeToMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}

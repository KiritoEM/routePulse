import 'package:hive_ce/hive_ce.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/local_db/models/delivery_item_model.dart';
import 'package:route_pulse_mobile/core/local_db/models/delivery_model.dart';
import 'package:route_pulse_mobile/features/deliveries/data/models/deliveries_dto.dart';
import 'package:route_pulse_mobile/features/deliveries/domain/entities/delivery.dart';

class DeliveriesLocalDatasource {
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

  Future<void> updateDelivery(DeliveryHiveModel delivery) async {
    await _deliveryBox.put(delivery.id, delivery);
  }

  bool checkIfIdExist(String id) {
    return _deliveryBox.containsKey(id);
  }

  List<Delivery> getAllDeliveries({
    DeliveryStatus? status,
    SortFilterEnum? sort,
  }) {
    List<Delivery> allDeliveries = _deliveryBox.keys
        .map((id) => _getDeliveryWithArticles(id as String))
        .whereType<Delivery>()
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

    final articles = _getArticlesForDelivery(id);
    return DeliveryDto.fromJson({
      ...hiveDelivery.toMap(),
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

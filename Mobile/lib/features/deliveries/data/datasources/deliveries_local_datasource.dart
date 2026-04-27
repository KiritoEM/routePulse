import 'package:hive_ce/hive_ce.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/local_db/models/delivery_model.dart';

class DeliveriesLocalDatasource {
  final Box<DeliveryHiveModel> _deliveryBox = Hive.box('deliveries');

  Future<void> saveNewDelivery(DeliveryHiveModel delivery) async {
    await _deliveryBox.put(delivery.id, delivery);
  }

  List<DeliveryHiveModel> getAllDeliveries({
    DeliveryStatus? status,
    SortFilterEnum? sort,
  }) {
    List<DeliveryHiveModel> allDeliveries = _deliveryBox.values.toList();

    if (status != null) {
      allDeliveries = allDeliveries
          .where((delivery) => delivery.status == status.value)
          .toList();
    }

    if (sort != null) {
      switch (sort) {
        case SortFilterEnum.timeSlot:
          allDeliveries.sort((a, b) {
            final aTime =
                int.parse(a.timeSlotStart.split(':')[0]) * 60 +
                int.parse(a.timeSlotStart.split(':')[1]);
            final bTime =
                int.parse(b.timeSlotStart.split(':')[0]) * 60 +
                int.parse(b.timeSlotStart.split(':')[1]);

            return aTime.compareTo(bTime);
          });
          break;
        case SortFilterEnum.creationDate:
          allDeliveries.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          break;
      }
    }

    return allDeliveries;
  }

  List<DeliveryHiveModel> getAllUnsyncedDeliveries() {
    return _deliveryBox.values
        .where((delivery) => delivery.isSynced == false)
        .toList();
  }

  Future<void> markAsSynced(String id, DeliveryHiveModel delivery) async {
    await _deliveryBox.put(id, delivery);
  }
}

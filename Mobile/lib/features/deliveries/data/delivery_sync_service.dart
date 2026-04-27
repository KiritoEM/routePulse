import 'package:route_pulse_mobile/features/deliveries/data/datasources/deliveries_local_datasource.dart';

class DeliverySyncService {
  final DeliveriesLocalDatasource _deliverieslocaldatasource =
      DeliveriesLocalDatasource();

  Future<void> syncUnsyncedData() async {
    // Pull data from the remote datasource and resolve conflict
  }
}

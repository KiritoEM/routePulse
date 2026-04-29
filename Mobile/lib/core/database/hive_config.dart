import 'package:hive_ce/hive_ce.dart';
import 'package:route_pulse_mobile/core/local_db/models/client_model.dart';
import 'package:route_pulse_mobile/core/local_db/models/delivery_item_model.dart';
import 'package:route_pulse_mobile/core/local_db/models/delivery_model.dart';
import 'package:route_pulse_mobile/core/local_db/models/user_model.dart';
import 'package:route_pulse_mobile/core/local_db/models/vehicle_model.dart';

class HiveConfig {
  static Future init(String path) async {
    Hive.init(path);

    // register adapters
    Hive.registerAdapter(UserHiveModelAdapter());
    Hive.registerAdapter(DeliveryHiveModelAdapter());
    Hive.registerAdapter(DeliveryItemHiveModelAdapter());
    Hive.registerAdapter(ClientHiveModelAdapter());
    Hive.registerAdapter(VehicleHiveModelAdapter());

    // open boxs
    await Hive.openBox<UserHiveModel>('users');
    await Hive.openBox<DeliveryHiveModel>('deliveries');
    await Hive.openBox<DeliveryItemHiveModel>('delivery_items');
    await Hive.openBox<ClientHiveModel>('clients');
    await Hive.openBox<VehicleHiveModel>('vehicles');
  }
}

import 'package:hive_ce/hive_ce.dart';
import 'package:route_pulse_mobile/features/user/domain/entities/user.dart';

class HiveConfig {
  static Future init(String path) async {
    Hive.init(path);

    // register adapters
    Hive.registerAdapter(UserAdapter());

    // open boxs
    await Hive.openBox<User>('users');
  }
}

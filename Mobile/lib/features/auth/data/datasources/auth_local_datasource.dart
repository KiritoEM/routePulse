import 'package:hive_ce/hive_ce.dart';
import 'package:route_pulse_mobile/core/local_db/models/user_model.dart';

class AuthLocalDatasource {
  final Box<UserHiveModel> _userBox = Hive.box('users');

  Future<void> saveNewUser(UserHiveModel user) async {
    await _userBox.put(user.id, user);
  }

  UserHiveModel? getUserByEmail(String email) {
    try {
      return _userBox.values.firstWhere((user) => user.email == email.trim());
    } catch (_) {
      return null;
    }
  }

  UserHiveModel? getUserById(String id) {
    return _userBox.get(id);
  }
}

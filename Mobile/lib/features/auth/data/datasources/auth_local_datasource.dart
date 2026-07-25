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

  // keep local biometric flag aligned with the backend one
  Future<void> updateBiometricEnabled(String id, bool enabled) async {
    final user = _userBox.get(id);

    if (user == null || user.biometricEnabled == enabled) return;

    await _userBox.put(
      id,
      UserHiveModel(
        id: user.id,
        email: user.email,
        password: user.password,
        biometricEnabled: enabled,
        createdAt: user.createdAt,
        updatedAt: DateTime.now(),
        isDeleted: user.isDeleted,
      ),
    );
  }
}

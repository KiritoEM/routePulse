import 'package:flutter/widgets.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:route_pulse_mobile/features/user/domain/entities/user.dart';

class AuthLocalDatasource {
  final Box<User> _userBox = Hive.box('users');

  Future saveNewUser(User user) async {
    await _userBox.put(user.id, user);
    debugPrint('Utilisateur save avec succes: ${user.toString()}');
  }
}

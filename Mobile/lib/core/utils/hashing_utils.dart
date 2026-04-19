import 'package:bcrypt/bcrypt.dart';

class HashingUtils {
  static String hashString(String text) {
    return BCrypt.hashpw(text, BCrypt.gensalt());
  }

  static bool verify(String text, String hashed) {
    return BCrypt.checkpw(text, hashed);
  }
}

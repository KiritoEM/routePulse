import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class JwtService {
  static final String _jwtSecretKey = dotenv.env['JWT_SECRET_KEY']!;

  static String createToken({
    required Map<String, dynamic> payload,
    Duration expiresIn = const Duration(hours: 12),
  }) {
    final jwt = JWT(payload);

    return jwt.sign(SecretKey(_jwtSecretKey), expiresIn: expiresIn);
  }

  static dynamic decodeToken(String token) {
    return JWT.decode(token) as dynamic;
  }
}

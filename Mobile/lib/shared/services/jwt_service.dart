import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/utils/app_logger.dart';
import 'package:route_pulse_mobile/shared/states/jwt_result.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class JwtService {
  JwtService._();

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

  static bool checkExpiry(String token) => JwtDecoder.isExpired(token);

  static Future<JwtResult> verifyToken(String token) async {
    try {
      final jwt = JWT.verify(token, SecretKey(_jwtSecretKey));

      return JwtResult(result: JwtVerifyResult.success, payload: jwt.payload);
    } on JWTExpiredException {
      return JwtResult(result: JwtVerifyResult.expired);
    } on JWTException catch (err) {
      AppLogger.logger.e('An error was occured when decoding token: $err');
      return JwtResult(result: JwtVerifyResult.error);
    }
  }
}

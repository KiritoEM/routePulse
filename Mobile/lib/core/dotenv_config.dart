import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:route_pulse_mobile/core/utils/app_logger.dart';

class DotenvConfig {
  static Future initDotenv() async {
    try {
      await dotenv.load(fileName: 'assets/.env');
    } catch (e) {
      AppLogger.logger.e('Error loading .env file: $e');
    }
  }
}

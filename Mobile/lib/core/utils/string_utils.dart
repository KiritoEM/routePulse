import 'package:route_pulse_mobile/core/utils/app_logger.dart';

class StringUtils {
  // ignore: strict_top_level_inference
  static formatTime(String time) {
    final String hour = time.split(':')[0];
    final String minutes = time.split(':')[1];

    if (minutes == '00') {
      return '$hour h';
    }

    final formattedMinutes = minutes.startsWith('0') ? minutes[0] : minutes;
    return '$hour\h $formattedMinutes';
  }

  static formatTimeSlot(String? start, String? end) {
    if (start == null && end == null) {
      return 'N/A';
    }

    try {
      return '${formatTime(start!)} - ${formatTime(end!)}';
    } catch (e) {
      AppLogger.logger.e('Error formatting time slot: $e');
      return 'Horaire non défini';
    }
  }
}

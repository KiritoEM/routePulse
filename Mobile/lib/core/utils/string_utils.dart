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
}

class DurationUtils {
  static Map<String, dynamic> formatDurationForDisplay(Duration duration) {
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;

    return {'hours': hours, 'minutes': minutes, 'seconds': seconds};
  }
}

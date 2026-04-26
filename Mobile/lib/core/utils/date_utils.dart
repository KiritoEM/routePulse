import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateUtils {
  static String formatDate(DateTime date) =>
      DateFormat('dd/MM/yy').format(date);

  static String formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

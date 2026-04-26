import 'dart:convert';
import 'dart:io';

class FileUtils {
  static String convertFileToBase64(File file) {
    final bytes = file.readAsBytesSync();

    return base64Encode(bytes).toString();
  }
  }

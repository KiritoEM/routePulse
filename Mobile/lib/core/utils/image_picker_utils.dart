import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:route_pulse_mobile/core/utils/app_logger.dart';
import 'package:route_pulse_mobile/shared/states/api_reponse.dart';

class ImagePickerUtils {
  static Future<ApiResponse> pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxHeight: 1920,
        maxWidth: 1920,
      );

      if (picked == null) {
        return ApiResponse(message: 'Aucune image téléchargée');
      }

      final file = File(picked.path);
      final fileSize = await file.length();

      if (fileSize > 10 * 1024 * 1024) {
        return ApiResponse(
          hasError: true,
          message: 'L\'image est trop volumineuse (max 10MB)',
        );
      }

      return ApiResponse(
        data: {
          'file': file,
          'originalName': picked.name,
          'mimeType': picked.mimeType,
        },
      );
    } catch (e) {
      AppLogger.logger.e('Error picking image: $e');
      return ApiResponse(
        hasError: true,
        message: 'Erreur lors du chargement de l\'image',
      );
    }
  }
}

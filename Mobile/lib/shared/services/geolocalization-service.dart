import 'package:geolocator/geolocator.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/shared/states/api_reponse.dart';

class Geolocalization {
  static Future<ApiResponse<Map<String, dynamic>>> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return ApiResponse(
          hasError: true,
          errorType: NetworkErrorType.unknown,
          message: 'Les services de localisation sont désactivés.',
        );
      }

      // Check the status of permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return ApiResponse(
            hasError: true,
            errorType: NetworkErrorType.forbidden,
            message: 'Les permissions de localisation sont refusées.',
          );
        }
      }

      // If permissions are permanently denied, throw an error
      if (permission == LocationPermission.deniedForever) {
        return ApiResponse(
          hasError: true,
          errorType: NetworkErrorType.forbidden,
          message:
              'Les permissions de localisation sont définitivement refusées.',
        );
      }

      // Get current location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return ApiResponse(
        data: {'lat': position.latitude, 'lng': position.longitude},
      );
    } catch (e) {
      return ApiResponse(
        hasError: true,
        errorType: NetworkErrorType.unknown,
        message: 'Erreur lors de la récupération de la position : $e',
      );
    }
  }
}

import 'package:geocoding/geocoding.dart';
import 'package:route_pulse_mobile/core/utils/app_logger.dart';

class GeocodingService {
  GeocodingService._();

  static Future<String?> getCityFromCoordinates({
    required double lat,
    required double lng,
  }) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isEmpty) {
        AppLogger.logger.w('No place found');
        return null;
      }

      // extract the city name
      Placemark placemark = placemarks.first;
      String? city = placemark.locality;

      if (city != null && city.isNotEmpty) {
        return city;
      }

      AppLogger.logger.w('City not found in placemark');
      return null;
    } catch (err) {
      AppLogger.logger.e('');
      return null;
    }
  }
}

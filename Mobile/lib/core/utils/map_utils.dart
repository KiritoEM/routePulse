import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapUtils {
  static Marker buildMarker(LatLng position) {
    return Marker(
      markerId: const MarkerId('selected_location'),
      position: position,
      infoWindow: const InfoWindow(title: 'adresse sélectionnée'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
  }
}

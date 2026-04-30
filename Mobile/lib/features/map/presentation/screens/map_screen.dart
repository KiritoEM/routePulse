import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_pulse_mobile/core/utils/app_toast.dart';
import 'package:route_pulse_mobile/features/deliveries/domain/entities/delivery.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/notifiers/deliveries_list_notifier.dart';
import 'package:route_pulse_mobile/features/map/presentation/widgets/delivery_bottomsheet.dart';
import 'package:route_pulse_mobile/shared/services/geolocalization_service.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/widgets/app_bottom_navigation.dart';

class MapScreen extends ConsumerStatefulWidget {
  final double? initialLat;
  final double? initialLng;

  const MapScreen({super.key, this.initialLat, this.initialLng});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  static const LatLng _defaultPosition = LatLng(-18.91368, 47.53613);
  LatLng _currentPosition = _defaultPosition;

  @override
  void initState() {
    super.initState();

    if (widget.initialLat != null && widget.initialLng != null) {
      _currentPosition = LatLng(widget.initialLat!, widget.initialLng!);
    }

    _getCurrentLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  double _colorToHue(Color color) {
    final HSVColor hsv = HSVColor.fromColor(color);
    return hsv.hue;
  }

  void _buildDeliveryLocation(List<Delivery> deliveries) {
    final deliveriesMarkers = <Marker>{};

    for (final delivery in deliveries) {
      deliveriesMarkers.add(
        Marker(
          markerId: MarkerId(delivery.id),
          position: LatLng(delivery.location[0], delivery.location[1]),
          infoWindow: InfoWindow(
            title: delivery.deliveryId,
            snippet: delivery.address,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            _colorToHue(delivery.status.color),
          ),
          onTap: () => DeliveryBottomsheet.show(context, delivery),
        ),
      );
    }

    if (mounted) {
      setState(() {
        _markers = {..._markers, ...deliveriesMarkers};
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    final result = await Geolocalization.getCurrentLocation();

    if (!mounted) return;

    if (result.hasError == true) {
      if (mounted) {
        AppToast.error(context, result.message ?? 'Erreur localisation');
      }
      return;
    }

    final lat = (result.data!['lat'] as num).toDouble();
    final lng = (result.data!['lng'] as num).toDouble();
    final position = LatLng(lat, lng);

    if (mounted) {
      setState(() {
        _currentPosition = position;
      });
    }

    if (widget.initialLat == null && widget.initialLng == null) {
      if (_mapController != null && mounted) {
        _mapController!.animateCamera(CameraUpdate.newLatLng(position));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(deliveriesListProvider, (previous, next) {
      if (next is HttpSuccess && mounted) {
        _buildDeliveryLocation(next.data as List<Delivery>);
      }
    });

    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 14,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (controller) {
          _mapController = controller;
          if (widget.initialLat != null && widget.initialLng != null) {
            controller.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(widget.initialLat!, widget.initialLng!),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: AppBottomNavigation(),
    );
  }
}

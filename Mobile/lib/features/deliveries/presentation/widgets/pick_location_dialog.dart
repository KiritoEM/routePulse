import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_pulse_mobile/core/utils/app_toast.dart';
import 'package:route_pulse_mobile/shared/services/geolocalization_service.dart';

class PickLocationDialog extends StatefulWidget {
  final Function(List<double> location) onSelect;
  final VoidCallback onCancel;

  const PickLocationDialog({
    super.key,
    required this.onSelect,
    required this.onCancel,
  });

  @override
  State<PickLocationDialog> createState() => _PickLocationDialogState();
}

class _PickLocationDialogState extends State<PickLocationDialog> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  static const LatLng _defaultPosition = LatLng(-18.91368, 47.53613);
  LatLng _selectedPosition = _defaultPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Marker _buildMarker(LatLng position) {
    return Marker(
      markerId: const MarkerId('selected_location'),
      position: position,
      infoWindow: const InfoWindow(title: 'adresse sélectionnée'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
  }

  Future<void> _getCurrentLocation() async {
    final result = await Geolocalization.getCurrentLocation();

    if (!mounted) return;

    if (result.hasError == true) {
      AppToast.error(context, result.message ?? 'Une erreur s\'est produite');

      setState(() {
        _selectedPosition = _defaultPosition;
        _buildMarker(_defaultPosition);
      });

      return;
    }

    final lat = (result.data!['lat'] as num).toDouble();
    final lng = (result.data!['lng'] as num).toDouble();
    final position = LatLng(lat, lng);

    _mapController?.animateCamera(CameraUpdate.newLatLng(position));

    setState(() {
      _selectedPosition = position;

      _markers = {_buildMarker(position)};
    });
  }

  void _onSelectLocation(LatLng position) {
    setState(() {
      _markers = {_buildMarker(position)};
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      title: const Text(
        'Choisir une localisation',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Sélectionnez un point sur la carte pour définir la position de livraison',
            style: TextStyle(color: AppColors.mutedForeground),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 400,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _selectedPosition,
                      zoom: 17,
                    ),
                    markers: _markers,
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    onTap: _onSelectLocation,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  widget.onCancel();
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                  textStyle: TextStyle(fontSize: AppTypography.small),
                ),
                child: const Text('Annuler'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  widget.onSelect([
                    _selectedPosition.latitude,
                    _selectedPosition.longitude,
                  ]);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                  textStyle: TextStyle(fontSize: AppTypography.small),
                ),
                child: const Text('Sélectionner'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

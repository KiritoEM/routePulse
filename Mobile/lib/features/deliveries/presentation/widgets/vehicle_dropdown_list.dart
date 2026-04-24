import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/models/vehicle.dart';

class VehicleDropdownList extends StatelessWidget {
  const VehicleDropdownList({
    super.key,
    required this.vehicles,
    required this.onSelect,
    this.selectedId,
  });

  final List<Vehicle> vehicles;
  final String? selectedId;
  final void Function(Vehicle) onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: vehicles.map((v) {
          final isSelected = v.id == selectedId;
          return ListTile(
            onTap: () => onSelect(v),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.directions_car,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            title: Text(
              v.name,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              v.plate,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.foreground.withOpacity(0.5),
              ),
            ),
            trailing: isSelected
                ? Icon(Icons.check, color: AppColors.primary, size: 20)
                : null,
          );
        }).toList(),
      ),
    );
  }
}

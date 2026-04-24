import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/models/vehicle.dart';

class VehicleDropdownHeader extends StatelessWidget {
  const VehicleDropdownHeader({
    super.key,
    required this.selected,
    required this.isExpanded,
    required this.onTap,
    this.hasError = false,
  });

  final Vehicle? selected;
  final bool isExpanded;
  final VoidCallback onTap;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasError
                ? Theme.of(context).colorScheme.error
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selected?.name ?? 'Choisir un véhicule',
                style: TextStyle(
                  fontSize: 15,
                  color: selected != null
                      ? AppColors.foreground
                      : AppColors.foreground.withOpacity(0.4),
                ),
              ),
            ),
            Icon(
              isExpanded
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              color: AppColors.foreground.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}

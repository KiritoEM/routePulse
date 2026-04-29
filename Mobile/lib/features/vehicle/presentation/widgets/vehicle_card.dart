import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';

class VehicleCard extends StatelessWidget {
  final VehicleType vehicleType;
  final String vehicleName;
  final String? plateNumber;
  final bool isActive;
  final VoidCallback onTapMenu;

  const VehicleCard({
    super.key,
    required this.vehicleType,
    required this.vehicleName,
    this.plateNumber,
    required this.isActive,
    required this.onTapMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          height: 54,
          width: 54,
          decoration: BoxDecoration(
            color: AppColors.Primary100,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: CustomIcon(
            path: vehicleType.icon,
            color: AppColors.primary,
            width: 34,
          ),
        ),
        title: Text(
          vehicleName,
          style: TextStyle(fontSize: AppTypography.body + 1),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (plateNumber != null)
              Text(
                plateNumber!,
                style: TextStyle(
                  color: AppColors.mutedForeground,
                  fontSize: AppTypography.small,
                ),
              ),
            Text(
              vehicleType.label,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: AppTypography.small,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isActive)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.info,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Active',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            IconButton(
              onPressed: () => onTapMenu(),
              icon: const Icon(Icons.more_vert_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

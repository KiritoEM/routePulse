import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_pulse_mobile/core/constants/router_constant.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text('Actions rapides', style: TextStyle(fontSize: AppTypography.h5)),

          const SizedBox(height: 12),

          Wrap(
            spacing: 14,
            runSpacing: 16,
            children: [
              _buildActionCard('assets/icons/location.svg', 'Voir la tournée'),
              _buildActionCard(
                'assets/icons/profile.svg',
                'Gérer les clients',
                onTap: () => context.push(RouterConstant.CLIENT_ROUTE),
              ),
              _buildActionCard(
                'assets/icons/location.svg',
                'Gérer les véhicules',
                onTap: () => context.push(RouterConstant.VEHICLE_ROUTE),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            CustomIcon(path: icon, width: 24, color: AppColors.primary),
            Text(label, style: TextStyle(fontSize: AppTypography.small + 1)),
          ],
        ),
      ),
    );
  }
}

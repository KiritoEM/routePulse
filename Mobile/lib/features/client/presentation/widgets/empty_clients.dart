import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';

class EmptyClients extends StatelessWidget {
  final VoidCallback onCreate;

  const EmptyClients({super.key, required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.Primary100,
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.all(20),
              child: CustomIcon(
                path: 'assets/icons/profile.svg',
                width: 52,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 24),

            Column(
              spacing: 16,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Aucun client pour le moment',
                  style: TextStyle(
                    fontSize: AppTypography.h4 - 1.5,
                    height: 1.15,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Les nouveaux clients apparaîtront ici.',
                  style: TextStyle(color: AppColors.mutedForeground),
                  textAlign: TextAlign.center,
                ),
                IntrinsicWidth(
                  child: ElevatedButton.icon(
                    onPressed: onCreate,
                    icon: const Icon(Icons.add),
                    label: const Text('Créer un client'),
                    iconAlignment: IconAlignment.start,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

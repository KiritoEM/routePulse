import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';

class EmptyDeliveries extends StatelessWidget {
  final bool isFiltered;

  const EmptyDeliveries({super.key, this.isFiltered = false});

  @override
  Widget build(BuildContext context) {
    if (isFiltered) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Lottie.asset(
              'assets/lotties/empty_box.json',
              width: 245,
              height: 245,
              fit: BoxFit.fill,
            ),

            Text(
              'Aucun résultat',
              style: TextStyle(
                fontSize: AppTypography.h4,
              ),
            ),

            Text(
              'Aucune livraison ne correspond aux filtres',
              style: TextStyle(color: AppColors.mutedForeground),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Lottie.asset(
              'assets/lotties/empty_box.json',
              width: 245,
              height: 245,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 24),
            Column(
              spacing: 16,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Aucune livraison pour le moment',
                  style: TextStyle(
                    fontSize: AppTypography.h4 - 1.5,
                    height: 1.15,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Les nouvelles livraisons apparaîtront ici.',
                  style: TextStyle(color: AppColors.mutedForeground),
                  textAlign: TextAlign.center,
                ),
                IntrinsicWidth(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Créér une livraison'),
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

import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/shared/widgets/stepper_header.dart';

class DeliveryPlannification extends StatelessWidget {
  const DeliveryPlannification({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),
          StepperHeader(
            title: 'Plannification de livraison',
            description: Text(
              'Définissez les détails liés à la date et à l’organisation de la livraison',
              style: TextStyle(
                color: AppColors.mutedForeground,
                fontSize: AppTypography.body,
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

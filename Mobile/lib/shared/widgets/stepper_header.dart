import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';

class StepperHeader extends StatelessWidget {
  final String title;
  final String description;

  const StepperHeader({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Text(title, style: TextStyle(fontSize: AppTypography.h3 - 1, height: 1.2)),

        Text(description, style: TextStyle(color: AppColors.mutedForeground)),
      ],
    );
  }
}

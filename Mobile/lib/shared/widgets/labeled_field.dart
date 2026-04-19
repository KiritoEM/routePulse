import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';

class LabeledField extends StatelessWidget {
  final String label;
  final Widget children;

  const LabeledField({super.key, required this.label, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppTypography.small,
            fontWeight: .w500,
            color: AppColors.foreground,
          ),
          textAlign: .start,
        ),
        const SizedBox(height: 8),
        children,
      ],
    );
  }
}

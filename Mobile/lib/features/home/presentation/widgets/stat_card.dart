import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';

class StatCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final Widget icon;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisSize: MainAxisSize.max,
        spacing: 28,
        mainAxisAlignment: .spaceBetween,
        children: [
          IntrinsicWidth(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: icon,
            ),
          ),

          Column(
            crossAxisAlignment: .start,
            children: [
              Text(label, style: TextStyle(color: AppColors.mutedForeground)),

              const SizedBox(height: 2),

              Text(
                value.toString(),
                style: TextStyle(fontSize: AppTypography.h2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

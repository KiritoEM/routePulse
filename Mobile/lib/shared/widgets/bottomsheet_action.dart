import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';

class BottomsheetAction extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback onTap;
  final bool isDestructive;

  const BottomsheetAction({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        width: double.infinity,
        child: Row(
          children: [
            icon,
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: AppTypography.body,
                color: isDestructive ? Colors.red : AppColors.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

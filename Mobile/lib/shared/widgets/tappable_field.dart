import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';

class TappableField extends StatelessWidget {
  const TappableField({
    super.key,
    required this.text,
    required this.onTap,
    required this.hasValue,
    this.suffixIcon,
    this.hasError = false,
  });

  final String text;
  final VoidCallback onTap;
  final bool hasValue;
  final Widget? suffixIcon;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasError
                ? AppColors.error 
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  color: hasValue
                      ? AppColors.foreground
                      : AppColors.inputPlaceholderColor,
                ),
              ),
            ),

            if (suffixIcon != null)
              IconTheme(
                data: IconThemeData(color: AppColors.foreground, size: 20),
                child: suffixIcon!,
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';

final defaultPinTheme = PinTheme(
  width: 52,
  height: 52,
  textStyle: TextStyle(
    fontSize: AppTypography.body + 1,
    color: AppColors.foreground,
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(13),
    color: AppColors.surface,
  ),
);

final focusedPinTheme = defaultPinTheme.copyDecorationWith(
  border: Border.all(color: AppColors.primary, width: 1.5),
);

final errorPinTheme = defaultPinTheme.copyDecorationWith(
  border: Border.all(color: AppColors.destructive),
);

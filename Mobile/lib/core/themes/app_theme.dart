import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';

class AppTheme {
  static ThemeData theme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.foreground,
        outline: Colors.transparent,
      ),
      fontFamily: 'GeneralSans',
      textTheme: const TextTheme()
          .apply(
            fontFamily: 'GeneralSans',
            bodyColor: AppColors.foreground,
            displayColor: AppColors.foreground,
          )
          .copyWith(
            bodyMedium: TextStyle(
              fontSize: AppTypography.body,
              fontWeight: FontWeight.w500,
              color: AppColors.foreground,
            ),
          ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: AppColors.surface,
        hintStyle: TextStyle(color: AppColors.inputPlaceholderColor),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.grey[500],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          elevation: 0,
          disabledForegroundColor: AppColors.mutedForeground,
          textStyle: TextStyle(fontSize: AppTypography.body),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.foreground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          minimumSize: const Size(double.infinity, 50),
          textStyle: TextStyle(fontSize: AppTypography.body),
        ),
      ),
    );
  }
}

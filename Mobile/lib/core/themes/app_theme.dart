import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';

class AppTheme {
  static ThemeData theme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        brightness: Brightness.light,
        onSurface: AppColors.foreground,
      ),
      fontFamily: 'GeneralSans',
      textTheme: const TextTheme().apply(
        fontFamily: 'GeneralSans',
        bodyColor: AppColors.foreground,
        displayColor: AppColors.foreground,
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
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          elevation: 0.3,
          disabledForegroundColor: AppColors.mutedForeground,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.foreground,
          side: BorderSide(color: Colors.grey[400]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          elevation: 0.3,
        ),
      ),
    );
  }
}

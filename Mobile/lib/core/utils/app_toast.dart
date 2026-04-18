import 'package:flutter/material.dart';
import 'package:my_toastify/my_toastify.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';

class AppToast {
  static void success(BuildContext context, String message) {
    Toastify.show(
      context,
      message: message,
      type: ToastType.success,
      backgroundColor: AppColors.success, 
      );
  }

  static void error(BuildContext context, String message) {
    Toastify.show(
      context,
      message: message,
      type: ToastType.error,
      backgroundColor: AppColors.error,
    );
  }

  static void info(BuildContext context, String message) {
    Toastify.show(
      context,
      message: message,
      type: ToastType.info,
      backgroundColor: AppColors.info,
    );
  }
}

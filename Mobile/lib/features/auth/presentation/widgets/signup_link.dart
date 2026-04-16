import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';

class SignupLink extends StatelessWidget {
  const SignupLink({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        text: 'Vous n’avez pas encore de compte?',
        style: TextStyle(
          color: AppColors.foreground,
          fontSize: AppTypography.body,
        ),
        children: [
          const TextSpan(
            text: ' S\'inscrire',
            style: TextStyle(fontWeight: .w600, color: AppColors.info),
          ),
        ],
      ),
    );
  }
}

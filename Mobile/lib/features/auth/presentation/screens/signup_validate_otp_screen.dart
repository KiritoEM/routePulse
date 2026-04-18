import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/features/auth/presentation/widgets/signup_validate_otp_form.dart';
import 'package:route_pulse_mobile/shared/widgets/stepper_header.dart';

class SignupValidateOtpScreen extends StatelessWidget {
  final String verificationToken;

  const SignupValidateOtpScreen({super.key, required this.verificationToken});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),

          // Header
          StepperHeader(
            title: 'Validation du code de vérification',
            description: RichText(
              text: TextSpan(
                text:
                    'Entrez le code de vérification envoyé à l’adresse e-mail:',
                style: TextStyle(
                  color: AppColors.mutedForeground,
                  fontSize: AppTypography.body,
                ),
                children: [
                  TextSpan(
                    text: ' “johankirito64@gmail.com”',
                    style: TextStyle(
                      fontWeight: .w600,
                      color: AppColors.primary,
                      fontSize: AppTypography.body,
                    ),
                  ),
                  TextSpan(
                    text: 'pour confirmer votre inscription',
                    style: TextStyle(
                      color: AppColors.mutedForeground,
                      fontSize: AppTypography.body,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),

          SignupValidateOtpForm(verificationToken: verificationToken),
        ],
      ),
    );
  }
}

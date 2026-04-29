import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/features/auth/presentation/widgets/login_link.dart';
import 'package:route_pulse_mobile/features/auth/presentation/widgets/signup_user_infos_form.dart';
import 'package:route_pulse_mobile/shared/widgets/stepper_header.dart';

class SignupUserInfosScreen extends StatelessWidget {
  const SignupUserInfosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      clipBehavior: .none,

      child: Column(
        children: [
          const SizedBox(height: 24),

          StepperHeader(
            title: 'Entrez vos informations personnelles',
            description: Text(
              'Renseignez vos informations pour créer votre compte RouterPulse',
              style: TextStyle(
                color: AppColors.mutedForeground,
                fontSize: AppTypography.body,
              ),
            ),
          ),

          const SizedBox(height: 32),

          SignupUserInfosForm(),

          const SizedBox(height: 32),

          const LoginLink(),
        ],
      ),
    );
  }
}

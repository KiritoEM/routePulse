import 'package:flutter/cupertino.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/features/auth/presentation/widgets/signup_create_password_form.dart';
import 'package:route_pulse_mobile/shared/widgets/stepper_header.dart';

class SignupCreatePasswordScreen extends StatelessWidget {
  final String creationToken;

  const SignupCreatePasswordScreen({super.key, required this.creationToken});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      clipBehavior: .none,

      child: Column(
        children: [
          const SizedBox(height: 24),

          StepperHeader(
            title: 'Créer votre \nmot de passe',
            description: Text(
              'Le mot de passe doit contenir au moins 8 caractères, incluant des lettres et des chiffres',
              style: TextStyle(
                color: AppColors.mutedForeground,
                fontSize: AppTypography.body,
              ),
            ),
          ),

          const SizedBox(height: 32),

          SignupCreatePasswordForm(creationToken: creationToken),
        ],
      ),
    );
  }
}

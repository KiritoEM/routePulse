import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/features/auth/presentation/widgets/signup_user_infos_form.dart';
import 'package:route_pulse_mobile/shared/widgets/stepper_header.dart';

class SignupUserInfosScreen extends StatelessWidget {
  const SignupUserInfosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),

          StepperHeader(
            title: 'Entrez vos informations personnelles',
            description:
                'Renseignez vos informations pour créer votre compte RouterPulse',
          ),

          const SizedBox(height: 32),

          SignupUserInfosForm(),
        ],
      ),
    );
  }
}

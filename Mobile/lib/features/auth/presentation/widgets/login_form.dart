import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';
import 'package:route_pulse_mobile/shared/widgets/labeled_field.dart';
import 'package:route_pulse_mobile/shared/widgets/password_field.dart';

class LoginForm extends ConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      child: Column(
        crossAxisAlignment: .end,
        children: [
          LabeledField(
            label: 'Adresse email',
            children: SizedBox(
              height: 55,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Votre adresse email',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(16),
                    child: CustomIcon(path: 'assets/icons/mail.svg'),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          LabeledField(
            label: 'Mot de passe',
            children: SizedBox(
              height: 55,
              child: PasswordField(hint: '********'),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Mot de passe oublié?',
            style: TextStyle(
              fontWeight: .w600,
              fontSize: AppTypography.small,
              color: AppColors.info,
            ),
          ),

          const SizedBox(height: 24),

          ElevatedButton(onPressed: () {}, child: Text('Se connecter')),

          const SizedBox(height: 24),

          Row(
            spacing: 16,
            children: [
              Expanded(
                child: const Divider(height: 1, color: AppColors.divider),
              ),

              Text('OU', style: TextStyle(fontSize: AppTypography.small)),

              Expanded(
                child: const Divider(height: 1, color: AppColors.divider),
              ),
            ],
          ),

          const SizedBox(height: 24),

          OutlinedButton.icon(
            onPressed: () {},
            label: Text(' Continuer avec Biométrie'),
            icon: CustomIcon(path: 'assets/icons/finger-scan.svg', width: 22),
          ),
        ],
      ),
    );
  }
}

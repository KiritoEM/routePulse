import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_toastify/my_toastify.dart';
import 'package:route_pulse_mobile/core/constants/regex_constant.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/features/auth/presentation/notifiers/login_notifier.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/widgets/button_with_loader.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';
import 'package:route_pulse_mobile/shared/widgets/labeled_field.dart';
import 'package:route_pulse_mobile/shared/widgets/password_field.dart';

class LoginForm extends ConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginProvider);
    final loginVm = ref.read(loginProvider.notifier);

    ref.listen(loginProvider, (previous, next) {
      if (previous is HttpLoading && next is HttpSuccess) {
        Toastify.show(context, message: 'Connexion reussie', type: .success);
        return;
      }

      if (next is HttpError) {
        Toastify.show(
          context,
          message: next.message,
          backgroundColor: AppColors.error,
          type: .error,
        );
      }
    });

    return Form(
      key: loginVm.formkey,
      child: Column(
        crossAxisAlignment: .end,
        children: [
          LabeledField(
            label: 'Adresse email',
            children: TextFormField(
              enabled: loginState is! HttpLoading,
              keyboardType: .emailAddress,
              decoration: InputDecoration(
                hintText: 'Votre adresse email',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(16),
                  child: CustomIcon(path: 'assets/icons/mail.svg'),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez entrer une adresse email';
                }

                if (!RegExp(RegexConstant.EMAIL_REGEX).hasMatch(value.trim())) {
                  return 'Veuillez entrer une adresse email valide';
                }

                return null;
              },
              onSaved: (value) => {
                if (value != null) {loginVm.setEmail(value.trim())},
              },
            ),
          ),

          const SizedBox(height: 16),

          LabeledField(
            label: 'Mot de passe',
            children: PasswordField(
              enabled: loginState is! HttpLoading,
              hint: '********',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez entrer un mot de passe';
                }

                if (!RegExp(
                  RegexConstant.PASSWORD_REGEX,
                ).hasMatch(value.trim())) {
                  return 'Le mot de passe doit contenir au moins une majuscule et un chiffre';
                }

                if (value.trim().length < 8) {
                  return 'Le mot de passe doit contenir au moins 8 caractères';
                }

                return null;
              },
              onSaved: (value) {
                if (value != null) {
                  loginVm.setPassword(value.trim());
                }
              },
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

          ButtonWithLoader(
            text: 'Se connecter',
            loadingText: 'Connexion en cours...',
            isLoading: loginState is HttpLoading,
            onPressed: loginState is HttpLoading
                ? null
                : () {
                    loginVm.submit();
                  },
          ),

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

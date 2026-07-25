import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:route_pulse_mobile/core/constants/regex_constant.dart';
import 'package:route_pulse_mobile/core/constants/router_constant.dart';
import 'package:route_pulse_mobile/core/utils/app_toast.dart';
import 'package:route_pulse_mobile/features/auth/presentation/notifiers/create_password_notifier.dart';
import 'package:route_pulse_mobile/features/auth/presentation/widgets/biometric_dialog_consent.dart';
import 'package:route_pulse_mobile/shared/services/biometric_auth_service.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/widgets/button_with_loader.dart';
import 'package:route_pulse_mobile/shared/widgets/labeled_field.dart';
import 'package:route_pulse_mobile/shared/widgets/password_field.dart';

class SignupCreatePasswordForm extends ConsumerWidget {
  final String creationToken;

  const SignupCreatePasswordForm({super.key, required this.creationToken});

  Future<void> _handleBiometricAuthenticate(
    BuildContext context,
    CreatePasswordNotifier createPasswordVm,
  ) async {
    // no biometric if device can't handle it
    if (!await BiometricAuthService.isBiometricAvailable()) {
      if (context.mounted) {
        AppToast.info(
          context,
          'Erreur lors de l’activation. Activez la biométrie dans les paramètres après inscription.',
        );
      }

      createPasswordVm.setBiometricEnabled(false);
      await createPasswordVm.submit();
      return;
    }

    final authenticationResponse = await BiometricAuthService.authenticate();

    if (authenticationResponse.hasError == true && context.mounted) {
      AppToast.error(context, authenticationResponse.message!);
    }

    // enabled only if the prompt succeed
    createPasswordVm.setBiometricEnabled(authenticationResponse.data == true);

    await createPasswordVm.submit();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createPasswordState = ref.watch(
      createPasswordProvider(creationToken),
    );
    final createPasswordVm = ref.read(
      createPasswordProvider(creationToken).notifier,
    );

    ref.listen(createPasswordProvider(creationToken), (previous, next) async {
      if (previous is HttpLoading && next is HttpSuccess) {
        context.go(RouterConstant.HOME_ROUTE);

        return;
      }

      if (next is HttpError) {
        AppToast.error(context, next.message);
      }
    });

    return Form(
      key: createPasswordVm.formkey,
      child: Column(
        children: [
          LabeledField(
            label: 'Nouveau mot de passe ',
            children: PasswordField(
              enabled: createPasswordState is! HttpLoading,
              controller: createPasswordVm.passwordController,
              hint: 'Votre nouveau mot de passe',
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
            ),
          ),

          const SizedBox(height: 16),

          LabeledField(
            label: 'Confirmer le mot de passe',
            children: PasswordField(
              enabled: createPasswordState is! HttpLoading,
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

                if (value.trim() != createPasswordVm.passwordController.text) {
                  return 'Les mots de passe ne correspondent pas';
                }

                return null;
              },
              onSaved: (value) {
                if (value != null) {
                  createPasswordVm.setConfirmedPassword(value.trim());
                }
              },
            ),
          ),

          const SizedBox(height: 24),

          ButtonWithLoader(
            text: 'Confirmer',
            loadingText: 'Confirmation en cours..',
            isLoading: createPasswordState is HttpLoading,
            onPressed: createPasswordState is HttpLoading
                ? null
                : () {
                    if (!createPasswordVm.formkey.currentState!.validate()) {
                      return;
                    }

                    _showConsentDialog(context, createPasswordVm);
                  },
          ),
        ],
      ),
    );
  }

  void _showConsentDialog(
    BuildContext context,
    CreatePasswordNotifier createPasswordVm,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BiometricDialogConsent(
        // account still created, without biometric
        onCancel: () {
          createPasswordVm.setBiometricEnabled(false);
          createPasswordVm.submit();
        },
        onEnable: () => _handleBiometricAuthenticate(context, createPasswordVm),
      ),
    );
  }
}

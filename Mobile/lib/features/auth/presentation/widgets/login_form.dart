import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_pulse_mobile/core/constants/regex_constant.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/core/utils/app_toast.dart';
import 'package:route_pulse_mobile/features/auth/presentation/notifiers/biometric_login_notifier.dart';
import 'package:route_pulse_mobile/features/auth/presentation/notifiers/check_biometric_state_notifier.dart';
import 'package:route_pulse_mobile/features/auth/presentation/notifiers/login_notifier.dart';
import 'package:route_pulse_mobile/shared/services/biometric_auth_service.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/widgets/button_with_loader.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';
import 'package:route_pulse_mobile/shared/widgets/labeled_field.dart';
import 'package:route_pulse_mobile/shared/widgets/password_field.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class LoginForm extends ConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginProvider);
    final loginVm = ref.read(loginProvider.notifier);
    final biometricLoginState = ref.watch(biometricLoginProvider);
    final biometricLoginVm = ref.read(biometricLoginProvider.notifier);
    final checkBiometricState = ref.watch(checkBiometricStateProvider);

    ref.listen(loginProvider, (previous, next) {
      if (previous is HttpLoading && next is HttpSuccess) {
        AppToast.success(context, 'Connexion reussie');
        return;
      }

      if (next is HttpError) {
        AppToast.error(context, next.message);
      }
    });

    ref.listen(biometricLoginProvider, (previous, next) {
      if (previous is HttpLoading && next is HttpSuccess) {
        AppToast.success(context, next.message!);
        return;
      }

      if (next is HttpError) {
        AppToast.error(context, next.message);
      }
    });

    Future<bool> canShowBiometricButton() async {
      return await BiometricAuthService.checkIsBiometricSupported() &&
          await BiometricAuthService.checkBiometrics() &&
          (checkBiometricState is HttpSuccess &&
              checkBiometricState.data == true);
    }

    Future<void> _handleBiometricAuthenticate(
      BuildContext context,
      BiometricLoginNotifier biometricLoginVm,
    ) async {
      final isBiometricSupported =
          await BiometricAuthService.checkIsBiometricSupported();
      final canCheckBiometrics = await BiometricAuthService.checkBiometrics();

      // check if biometric is supported by device
      if (!isBiometricSupported) {
        AppToast.info(
          context,
          'Votre appareil ne supporte pas l\'authentification biométrique.',
        );
        return;
      }

      // check if device can check biometrics
      if (!canCheckBiometrics) {
        AppToast.info(
          context,
          'Erreur lors de l’activation. Activez la biométrie dans les paramètres après inscription.',
        );
        return;
      }

      final authenticationResponse = await BiometricAuthService.authenticate();

      if (authenticationResponse.hasError!) {
        AppToast.error(context, authenticationResponse.message!);
        return;
      }

      if (authenticationResponse.isSucess &&
          authenticationResponse.data == true) {
        biometricLoginVm.submit();
      }
    }

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

          FutureBuilder<bool>(
            future: canShowBiometricButton(),
            builder: (context, snapshot) {
              if (snapshot.hasError && (checkBiometricState is! HttpLoading)) {
                return const SizedBox.shrink();
              }

              if (snapshot.hasData && (checkBiometricState is! HttpLoading)) {
                if (snapshot.data != true) {
                  return const SizedBox.shrink();
                } else {
                  return Column(
                    children: [
                      const SizedBox(height: 24),

                      Row(
                        spacing: 16,
                        children: [
                          Expanded(
                            child: const Divider(
                              height: 1,
                              color: AppColors.divider,
                            ),
                          ),
                          Text(
                            'OU',
                            style: TextStyle(fontSize: AppTypography.small),
                          ),
                          Expanded(
                            child: const Divider(
                              height: 1,
                              color: AppColors.divider,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      OutlinedButton.icon(
                        onPressed: biometricLoginState is HttpLoading
                            ? null
                            : () => _handleBiometricAuthenticate(
                                context,
                                biometricLoginVm,
                              ),
                        label: Text(
                          biometricLoginState is HttpLoading
                              ? ''
                              : 'Continuer avec Biométrie',
                        ),
                        icon: biometricLoginState is HttpLoading
                            ? SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.mutedForeground,
                                ),
                              )
                            : CustomIcon(
                                path: 'assets/icons/finger-scan.svg',
                                width: 22,
                              ),
                      ),
                    ],
                  );
                }
              }

              return Column(
                children: [
                  const SizedBox(height: 32),
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 55,
                      width: double.infinity,
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

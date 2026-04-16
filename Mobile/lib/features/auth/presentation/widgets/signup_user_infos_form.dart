import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_toastify/my_toastify.dart';
import 'package:route_pulse_mobile/core/constants/regex_constant.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/features/auth/presentation/notifiers/signup_infos_notifier.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/widgets/button_with_loader.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';
import 'package:route_pulse_mobile/shared/widgets/labeled_field.dart';

class SignupUserInfosForm extends ConsumerWidget {
  const SignupUserInfosForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _signupState = ref.watch(signupInfosProvider);
    final _signupVm = ref.read(signupInfosProvider.notifier);

    ref.listen(signupInfosProvider, (previous, next) {
      if (previous is HttpLoading && next is HttpSuccess) {
        Toastify.show(context, message: next.message!, type: .success);
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
      key: _signupVm.formkey,
      child: Column(
        children: [
          LabeledField(
            label: 'Nom complet',
            children: TextFormField(
              enabled: _signupState is! HttpLoading,
              keyboardType: .text,
              decoration: InputDecoration(
                hintText: 'ex: Rakoto Jean',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(16),
                  child: CustomIcon(path: 'assets/icons/profile.svg'),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez entrer un nom complet';
                }

                return null;
              },
              onSaved: (value) => {
                if (value != null) {_signupVm.setFullName(value.trim())},
              },
            ),
          ),

          const SizedBox(height: 16),

          LabeledField(
            label: 'Adresse email',
            children: TextFormField(
              enabled: _signupState is! HttpLoading,
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
                if (value != null) {_signupVm.setEmail(value.trim())},
              },
            ),
          ),

          const SizedBox(height: 24),

          ButtonWithLoader(
            text: 'S\'inscrire',
            loadingText: 'Connexion en cours...',
            isLoading: _signupState is HttpLoading,
            onPressed: _signupState is HttpLoading
                ? null
                : () {
                    _signupVm.submit();
                  },
          ),
        ],
      ),
    );
  }
}

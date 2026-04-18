import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_toastify/my_toastify.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/core/themes/otp_theme.dart';
import 'package:route_pulse_mobile/features/auth/presentation/notifiers/signup_resend_otp_notifier.dart';
import 'package:route_pulse_mobile/features/auth/presentation/notifiers/signup_validate_code_notifier.dart';
import 'package:pinput/pinput.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/widgets/button_with_loader.dart';
import 'package:route_pulse_mobile/shared/widgets/countdown.dart';

class SignupValidateOtpForm extends ConsumerStatefulWidget {
  final String verificationToken;

  const SignupValidateOtpForm({super.key, required this.verificationToken});

  @override
  ConsumerState<SignupValidateOtpForm> createState() =>
      _SignupValidateFormState();
}

class _SignupValidateFormState extends ConsumerState<SignupValidateOtpForm> {
  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(signupValidateCodeProvider(widget.verificationToken));
    final signupVm = ref.read(signupValidateCodeProvider(widget.verificationToken).notifier);
    final resendOtpVm = ref.read(signupResendOtpProvider(widget.verificationToken).notifier);

    ref.listen(signupValidateCodeProvider(widget.verificationToken), (previous, next) {
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

    ref.listen(signupResendOtpProvider(widget.verificationToken), (previous, next) {
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
      key: signupVm.formkey,
      child: Column(
        children: [
          Countdown(),

          const SizedBox(height: 24),

          FormField<String>(
            validator: (value) {
              if (signupVm.pintController.text.length < 6) {
                return 'Code OTP incomplet';
              }

              return null;
            },
            builder: (field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Pinput(
                    length: 6,
                    controller: signupVm.pintController,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    errorPinTheme: errorPinTheme,
                  ),
                  if (field.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 12),
                      child: Text(
                        field.errorText!,
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          RichText(
            text: TextSpan(
              text: 'Code non recu?',
              style: TextStyle(
                color: AppColors.foreground,
                fontSize: AppTypography.body,
              ),
              children: [
                TextSpan(
                  text: '  Renvoyer',
                  style: TextStyle(fontWeight: .w600, color: AppColors.info),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => resendOtpVm.resendOtp(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          ButtonWithLoader(
            text: 'Vérifier',
            loadingText: 'Vérification en cours...',
            isLoading: signupState is HttpLoading,
            onPressed: signupState is HttpLoading
                ? null
                : () {
                    signupVm.submit();
                  },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_toastify/my_toastify.dart';
import 'package:route_pulse_mobile/core/constants/router_constants.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/core/themes/otp_theme.dart';
import 'package:route_pulse_mobile/core/utils/app_toast.dart';
import 'package:route_pulse_mobile/features/auth/presentation/notifiers/signup_resend_otp_notifier.dart';
import 'package:route_pulse_mobile/features/auth/presentation/notifiers/signup_validate_code_notifier.dart';
import 'package:pinput/pinput.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/widgets/button_with_loader.dart';
import 'package:route_pulse_mobile/shared/widgets/countdown.dart';

class SignupValidateOtpForm extends ConsumerWidget {
  final String verificationToken;

  const SignupValidateOtpForm({super.key, required this.verificationToken});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final validateOtpState = ref.watch(
      signupValidateCodeProvider(verificationToken),
    );
    final validateOtpVm = ref.read(
      signupValidateCodeProvider(verificationToken).notifier,
    );
    final resendOtpVm = ref.read(
      signupResendOtpProvider(verificationToken).notifier,
    );

    ref.listen(signupValidateCodeProvider(verificationToken), (previous, next) {
      if (previous is HttpLoading && next is HttpSuccess) {
        if (!context.mounted) return;

        context.push('${RouterConstant.SIGNUP_STEP3_ROUTE}?creationToken=${next.data}');

        return;
      }

      if (next is HttpError) {
        if (!context.mounted) return;
        AppToast.error(context, next.message);
      }
    });

    ref.listen(signupResendOtpProvider(verificationToken), (previous, next) {
      if (previous is HttpLoading && next is HttpSuccess) {
        if (!context.mounted) return;
        Toastify.show(context, message: next.message!, type: .success);
        return;
      }

      if (next is HttpError) {
        if (!context.mounted) return;
        Toastify.show(
          context,
          message: next.message,
          backgroundColor: AppColors.error,
          type: .error,
        );
      }
    });

    return Form(
      key: validateOtpVm.formkey,
      child: Column(
        children: [
          Countdown(),

          const SizedBox(height: 24),

          FormField<String>(
            validator: (value) {
              if (validateOtpVm.pintController.text.length < 6) {
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
                    controller: validateOtpVm.pintController,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    errorPinTheme: errorPinTheme,
                    onCompleted: (pin) => validateOtpVm.submit(),
                                ),
                  if (field.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 12),
                      child: Text(
                        field.errorText!,
                        style: TextStyle(color: AppColors.error, fontSize: 12),
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
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.info,
                  ),
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
            isLoading: validateOtpState is HttpLoading,
            onPressed: validateOtpState is HttpLoading
                ? null
                : () => validateOtpVm.submit(),
          ),
        ],
      ),
    );
  }
}

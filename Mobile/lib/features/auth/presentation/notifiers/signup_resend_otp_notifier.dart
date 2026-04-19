import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/auth/data/auth_repository_impl.dart';
import 'package:route_pulse_mobile/features/auth/presentation/notifiers/signup_validate_code_notifier.dart';
import 'package:route_pulse_mobile/shared/notifiers/otp_countdown_notifier.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/states/resend_otp_credentials_state.dart';

part 'signup_resend_otp_notifier.g.dart';

@riverpod
class SignupResendOtpNotifier extends _$SignupResendOtpNotifier {
  final _authRepository = AuthRepositoryImpl();

  ResendOtpCredentialsState _credentials = ResendOtpCredentialsState(
    verificationToken: '',
  );

  void _setVerificationToken(String verificationToken) {
    _credentials = _credentials.copyWith(verificationToken: verificationToken);
  }

  @override
  HttpState build(String verificationToken) {
    _setVerificationToken(verificationToken);

    return HttpState.init();
  }

  Future<void> resendOtp() async {
    state = HttpState.loading();

    final response = await _authRepository.resendSignupOtp(_credentials);

    if (response.isSucess) {
      state = HttpState.success(message: response.message);
      final countdownVm = ref.read(otpCountdownProvider.notifier);
      final validateCodeVm = ref.read(signupValidateCodeProvider(_credentials.verificationToken).notifier);

      // update verificationToken 
      validateCodeVm.setVerificationToken(response.data);
      _setVerificationToken(response.data);

      countdownVm.resetTimer();

      return;
    }

    state = HttpState.error(
      errorType: response.errorType ?? NetworkErrorType.server,
      message: response.message ?? "Impossible de se connecter",
    );
  }
}

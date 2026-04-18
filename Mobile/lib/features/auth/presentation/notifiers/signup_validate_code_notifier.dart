import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/auth/data/auth_repository_impl.dart';
import 'package:route_pulse_mobile/features/auth/presentation/states/validate_otp_credentials_state.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

part 'signup_validate_code_notifier.g.dart';

@riverpod
class SignupValidateCodeNotifier extends _$SignupValidateCodeNotifier {
  final _authRepository = AuthRepositoryImpl();

  ValidateOtpCredentialsState _credentials = ValidateOtpCredentialsState(
    code: '',
    verificationToken: '',
  );
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _pinController = TextEditingController();

  // getters
  GlobalKey<FormState> get formkey => _formkey;
  TextEditingController get pintController => _pinController;

  void _setCode() {
    _credentials = _credentials.copyWith(code: _pinController.text);
  }

  void _setVerificationToken(String verificationToken) {
    _credentials = _credentials.copyWith(verificationToken: verificationToken);
  }

  @override
  HttpState build(String verificationToken) {
    _pinController.addListener(_setCode);
    ref.onDispose(() => _pinController.dispose());
    _setVerificationToken(verificationToken);

    return const HttpState.init();
  }

  Future<void> submit() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }

    state = HttpState.loading();

    final response = await _authRepository.validateSignupOtp(_credentials);

    if (response.isSucess) {
      state = HttpState.success(message: response.message, data: response.data);
      return;
    }

    state = HttpState.error(
      errorType: response.errorType ?? NetworkErrorType.server,
      message: response.message ?? "Impossible de valider le code OTP",
    );
  }
}

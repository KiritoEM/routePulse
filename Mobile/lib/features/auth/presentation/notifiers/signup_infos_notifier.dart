import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/auth/data/auth_repository_impl.dart';
import 'package:route_pulse_mobile/features/auth/presentation/states/signup_infos_credentials_state.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

part 'signup_infos_notifier.g.dart';

@riverpod
class SignupInfosNotifier extends _$SignupInfosNotifier {
  final _authRepository = AuthRepositoryImpl();

  SignupInfosCredentialsState _credentials = SignupInfosCredentialsState(
    email: '',
    fullName: '',
  );
  final _formkey = GlobalKey<FormState>();

  // getters
  GlobalKey<FormState> get formkey => _formkey;

  void setFullName(String fullName) {
    _credentials = _credentials.copyWith(fullName: fullName);
  }

  void setEmail(String email) {
    _credentials = _credentials.copyWith(email: email);
  }

  @override
  HttpState build() => const HttpState.init();

  Future<void> submit() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }

    _formkey.currentState!.save();

    state = HttpState.loading();

    final response = await _authRepository.signupAddUserInfos(_credentials);

    if (response.isSucess) {
      state = HttpState.success(message: response.message);
      return;
    }

    state = HttpState.error(
      errorType: response.errorType ?? NetworkErrorType.server,
      message: response.message ?? "Impossible d'envoyer le code OTP",
    );
  }
}

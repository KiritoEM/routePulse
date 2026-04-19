import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/auth/data/auth_repository_impl.dart';
import 'package:route_pulse_mobile/features/auth/presentation/states/login_credentials_state.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

part 'login_notifier.g.dart';

@riverpod
class LoginNotifier extends _$LoginNotifier {
  final _authRepository = AuthRepositoryImpl();

  LoginCredentialsState _credentials = const LoginCredentialsState(
    email: '',
    password: '',
  );
  final _formkey = GlobalKey<FormState>();

  // getters
  GlobalKey<FormState> get formkey => _formkey;

  @override
  HttpState build() => const HttpState.init();

  void setEmail(String email) {
    _credentials = _credentials.copyWith(email: email);
  }

  void setPassword(String password) {
    _credentials = _credentials.copyWith(password: password);
  }

  Future<void> submit() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }

    _formkey.currentState!.save();

    state = HttpState.loading();

    final response = await _authRepository.login(_credentials);

    if (response.isSucess) {
      state = HttpState.success();
      return;
    }

    state = HttpState.error(
      errorType: response.errorType ?? NetworkErrorType.server,
      message: response.message ?? "Impossible de se connecter",
    );
  }
}

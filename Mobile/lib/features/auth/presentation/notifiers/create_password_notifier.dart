import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/auth/data/auth_repository_impl.dart';
import 'package:route_pulse_mobile/features/auth/presentation/states/create_password_credentials_state.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

part 'create_password_notifier.g.dart';

@riverpod
class CreatePasswordNotifier extends _$CreatePasswordNotifier {
  final _authRepository = AuthRepositoryImpl();

  CreatePasswordCredentialsState _credentials = CreatePasswordCredentialsState(
    password: '',
    creationToken: '',
  );
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  // getters
  GlobalKey<FormState> get formkey => _formkey;
  TextEditingController get passwordController => _passwordController;

  void _setActionToken(String creationToken) {
    _credentials = _credentials.copyWith(creationToken: creationToken);
  }

  void setConfirmedPassword(String password) {
    _credentials = _credentials.copyWith(password: password);
  }

  @override
  HttpState build(String creationToken) {
    _setActionToken(creationToken);

    return HttpState.init();
  }

  Future<void> submit() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }

    _formkey.currentState!.save();

    state = HttpState.loading();

    final response = await _authRepository.createPassword(_credentials);

    if (response.isSucess) {
      state = HttpState.success();
      return;
    }

    state = HttpState.error(
      errorType: response.errorType ?? NetworkErrorType.server,
      message: response.message ?? 'Impossible de créer votre mot de passe',
    );
  }
}

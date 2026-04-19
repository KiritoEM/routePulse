import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/auth/data/auth_repository_impl.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

part 'biometric_login_notifier.g.dart';

@riverpod
class BiometricLoginNotifier extends _$BiometricLoginNotifier {
  final _authRepository = AuthRepositoryImpl();

  @override
  HttpState build() => const HttpState.init();

  Future<void> submit() async {
    state = HttpState.loading();

    final response = await _authRepository.loginWithBiometric();

    if (response.isSucess) {
      state = HttpState.success(message: response.message);
      return;
    }

    state = HttpState.error(
      errorType: response.errorType ?? NetworkErrorType.server,
      message: response.message ?? "Impossible de se connecter par biometrie",
    );
  }
}

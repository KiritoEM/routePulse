import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/auth/data/auth_repository_impl.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

part 'check_biometric_state_notifier.g.dart';

@riverpod
class CheckBiometricStateNotifier extends _$CheckBiometricStateNotifier {
  final _authRepository = AuthRepositoryImpl();

  @override
  HttpState build() {
    Future.microtask(() => _checkIsBiometricEnabled());
    return const HttpState.init();
  }

  Future<void> _checkIsBiometricEnabled() async {
    state = HttpLoading();

    final response = await _authRepository.checkIsBiometricEnabled();

    if (response.isSucess) {
      state = HttpState.success(data: response.data);
      return;
    }

    state = HttpState.error(
      errorType: response.errorType ?? NetworkErrorType.server,
      message: '',
    );
  }
}

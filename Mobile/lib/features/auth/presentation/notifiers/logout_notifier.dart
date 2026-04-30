import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/auth/data/auth_repository_impl.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

part 'logout_notifier.g.dart';

@riverpod
class LogoutNotifier extends _$LogoutNotifier {
  final _authRepository = AuthRepositoryImpl();

  @override
  HttpState build() => const HttpState.init();

  Future<void> logout() async {
    state = HttpState.loading();

    final response = await _authRepository.logout();

    if (response.isSucess) {
      state = HttpState.success();
      return;
    }

    state = HttpState.error(
      errorType: response.errorType ?? NetworkErrorType.server,
      message: response.message ?? 'Impossible de se déconnecter',
    );
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/auth/data/auth_repository_impl.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

part 'current_user_notifier.g.dart';

@riverpod
class CurrentUserNotifier extends _$CurrentUserNotifier {
  final AuthRepositoryImpl _authRepository = AuthRepositoryImpl();

  void startLoading() {
    state = const HttpState.loading();
  }

  Future<void> _fetchCurrentUser() async {
    state = const HttpState.loading();

    try {
      final response = await _authRepository.getCurrentUser();

      if (response.isSucess) {
        state = HttpState.success(
          message: response.message ?? 'Utilisateur chargé',
          data: response.data,
        );
        return;
      }

      state = HttpState.error(
        errorType: response.errorType ?? NetworkErrorType.server,
        message: response.message ?? 'Impossible de charger l\'utilisateur',
      );
    } catch (e) {
      state = HttpState.error(
        errorType: NetworkErrorType.server,
        message: 'Erreur inattendue',
      );
    }
  }

  Future<void> refetch() async {
    state = const HttpState.loading();
    await _fetchCurrentUser();
  }

  @override
  HttpState build() {
    _fetchCurrentUser();
    return const HttpState.loading();
  }
}

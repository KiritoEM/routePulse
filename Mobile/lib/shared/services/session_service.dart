import 'package:route_pulse_mobile/core/constants/key_constant.dart';
import 'package:route_pulse_mobile/core/constants/router_constant.dart';
import 'package:route_pulse_mobile/core/router/app_router.dart';
import 'package:route_pulse_mobile/core/utils/app_logger.dart';
import 'package:route_pulse_mobile/shared/services/secure_storage_service.dart';

class SessionService {
  SessionService._();

  static bool _isExpiring = false;

  // clear tokens and back to login
  static Future<void> expireSession() async {
    if (_isExpiring) return;
    _isExpiring = true;

    try {
      await SecureStorageService.delete(KeyConstant.kRemoteAccessToken);
      await SecureStorageService.delete(KeyConstant.kRemoteRefreshToken);
      await SecureStorageService.delete(KeyConstant.kLocalAccessToken);

      // active user kept for biometric login
      final currentRoute = AppRouter
          .router
          .routerDelegate
          .currentConfiguration
          .uri
          .path;

      if (currentRoute != RouterConstant.LOGIN_ROUTE) {
        AppRouter.router.go(RouterConstant.LOGIN_ROUTE);
      }
    } catch (err) {
      AppLogger.logger.e('Error while expiring session: $err');
    } finally {
      _isExpiring = false;
    }
  }
}

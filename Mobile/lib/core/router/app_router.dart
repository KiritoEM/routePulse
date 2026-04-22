import 'package:go_router/go_router.dart';
import 'package:route_pulse_mobile/core/constants/router_constants.dart';
import 'package:route_pulse_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:route_pulse_mobile/features/auth/presentation/screens/signup_create_password_screen.dart';
import 'package:route_pulse_mobile/features/auth/presentation/screens/signup_user_infos_screen.dart';
import 'package:route_pulse_mobile/features/auth/presentation/screens/signup_validate_otp_screen.dart';
import 'package:route_pulse_mobile/features/auth/presentation/widgets/signup_layout.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/screens/deliveries_screen.dart';
import 'package:route_pulse_mobile/features/onboarding/presentation/screens/onboarding_screen.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: RouterConstant.DELIVERIES_ROUTE,
    routes: [
      GoRoute(
        path: RouterConstant.DEFAULT_ROUTE,
        builder: (_, state) => OnboardingScreen(),
      ),
      GoRoute(
        path: RouterConstant.LOGIN_ROUTE,
        builder: (_, state) => LoginScreen(),
      ),
      ShellRoute(
        builder: (_, state, child) => SignupLayout(child: child),
        routes: [
          GoRoute(
            path: RouterConstant.SIGNUP_STEP1_ROUTE,
            builder: (_, state) => SignupUserInfosScreen(),
          ),
          GoRoute(
            path: RouterConstant.SIGNUP_STEP2_ROUTE,
            builder: (_, state) {
              final String verificationToken =
                  state.uri.queryParameters['verificationToken'] ?? '';
              final String email =
                  state.uri.queryParameters['email'] ?? 'email inconnu';

              return SignupValidateOtpScreen(
                verificationToken: verificationToken,
                email: email,
              );
            },
          ),
          GoRoute(
            path: RouterConstant.SIGNUP_STEP3_ROUTE,
            builder: (_, state) {
              final String creationToken =
                  state.uri.queryParameters['creationToken'] ?? '';

              return SignupCreatePasswordScreen(creationToken: creationToken);
            },
          ),
        ],
      ),

      GoRoute(
        path: RouterConstant.DELIVERIES_ROUTE,
        builder: (_, state) => DeliveriesScreen(),
      ),
    ],
  );
}

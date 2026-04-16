import 'package:go_router/go_router.dart';
import 'package:route_pulse_mobile/core/constants/router_constants.dart';
import 'package:route_pulse_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:route_pulse_mobile/features/auth/presentation/screens/signup_user_infos_screen.dart';
import 'package:route_pulse_mobile/features/auth/presentation/widgets/signup_layout.dart';
import 'package:route_pulse_mobile/features/onboarding/presentation/screens/onboarding_screen.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: RouterConstants.SIGNUP_STEP1_ROUTE,
    routes: [
      GoRoute(
        path: RouterConstants.DEFAULT_ROUTE,
        builder: (_, state) => OnboardingScreen(),
      ),
      GoRoute(
        path: RouterConstants.LOGIN_ROUTE,
        builder: (_, state) => LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => SignupLayout(child: child),
        routes: [
          GoRoute(
            path: RouterConstants.SIGNUP_STEP1_ROUTE,
            builder: (_, state) => SignupUserInfosScreen(),
          ),
        ],
      ),
    ],
  );
}

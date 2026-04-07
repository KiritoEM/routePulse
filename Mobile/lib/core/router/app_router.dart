import 'package:go_router/go_router.dart';
import 'package:route_pulse_mobile/core/constants/router_constants.dart';
import 'package:route_pulse_mobile/features/onboarding/presentation/screens/onboarding_screen.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: RouterConstants.DEFAULT_ROUTE,
    routes: [
      GoRoute(
        path: RouterConstants.DEFAULT_ROUTE,
        builder: (_, state) => OnboardingScreen(),
      ),
    ],
  );
}

import 'package:go_router/go_router.dart';
import 'package:route_pulse_mobile/core/constants/key_constant.dart';
import 'package:route_pulse_mobile/core/constants/router_constant.dart';
import 'package:route_pulse_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:route_pulse_mobile/features/auth/presentation/screens/signup_create_password_screen.dart';
import 'package:route_pulse_mobile/features/auth/presentation/screens/signup_user_infos_screen.dart';
import 'package:route_pulse_mobile/features/auth/presentation/screens/signup_validate_otp_screen.dart';
import 'package:route_pulse_mobile/features/auth/presentation/widgets/signup_layout.dart';
import 'package:route_pulse_mobile/features/client/presentation/screens/clients_screen.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/screens/create-delivery/add_article_screen.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/screens/create-delivery/add_client_infos_screen.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/screens/create-delivery/delivery_confirmation_screen.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/screens/create-delivery/delivery_planification_screen.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/screens/deliveries_screen.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/screens/delivery_details_screen.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/create_delivery_layout.dart';
import 'package:route_pulse_mobile/features/home/presentation/screens/home_screen.dart';
import 'package:route_pulse_mobile/features/map/presentation/screens/map_screen.dart';
import 'package:route_pulse_mobile/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:route_pulse_mobile/features/vehicle/presentation/screens/vehicle_screen.dart';
import 'package:route_pulse_mobile/shared/services/secure_storage_service.dart';

class AppRouter {
  static const _publicRoutes = [
    RouterConstant.DEFAULT_ROUTE,
    RouterConstant.LOGIN_ROUTE,
    RouterConstant.SIGNUP_STEP1_ROUTE,
    RouterConstant.SIGNUP_STEP2_ROUTE,
    RouterConstant.SIGNUP_STEP3_ROUTE,
  ];

  static const _authRoutes = [
    RouterConstant.DEFAULT_ROUTE,
    RouterConstant.LOGIN_ROUTE,
  ];

  static GoRouter router = GoRouter(
    initialLocation: RouterConstant.DEFAULT_ROUTE,
    redirect: (context, state) async {
      final remoteToken = await SecureStorageService.read(
        KeyConstant.kRemoteAccessToken,
      );
      final localToken = await SecureStorageService.read('local_acces_token');

      final bool hasToken = remoteToken != null || localToken != null;
      final bool isPublicRoute = _publicRoutes.contains(state.matchedLocation);
      final bool isAuthRoute = _authRoutes.contains(state.matchedLocation);

      if (hasToken && isAuthRoute) {
        return RouterConstant.HOME_ROUTE;
      }

      if (!hasToken && !isPublicRoute) {
        return RouterConstant.LOGIN_ROUTE;
      }

      return null;
    },
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
        path: RouterConstant.HOME_ROUTE,
        builder: (_, state) => HomeScreen(),
      ),
      GoRoute(
        path: RouterConstant.DELIVERIES_ROUTE,
        builder: (_, state) => DeliveriesScreen(),
      ),
      ShellRoute(
        builder: (_, state, child) => CreateDeliveryLayout(child: child),
        routes: [
          GoRoute(
            path: RouterConstant.CREATE_DELIVERY_STEP1,
            builder: (_, state) => AddClientInfosScreen(),
          ),
          GoRoute(
            path: RouterConstant.CREATE_DELIVERY_STEP2,
            builder: (_, state) => DeliveryPlanificationScreen(),
          ),
          GoRoute(
            path: RouterConstant.CREATE_DELIVERY_STEP3,
            builder: (_, state) => AddArticleScreen(),
          ),
          GoRoute(
            path: RouterConstant.CREATE_DELIVERY_STEP4,
            builder: (_, state) => DeliveryConfirmationScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '${RouterConstant.DELIVERY_DETAILS}/:deliveryId',
        builder: (_, state) {
          final deliveryId = state.pathParameters['deliveryId']!;
          return DeliveryDetailsScreen(deliveryId: deliveryId);
        },
      ),
      GoRoute(
        path: RouterConstant.VEHICLE_ROUTE,
        builder: (_, state) => VehicleScreen(),
      ),
      GoRoute(
        path: RouterConstant.CLIENT_ROUTE,
        builder: (_, state) => ClientsScreen(),
      ),
      GoRoute(
        path: RouterConstant.MAP_ROUTE,
        builder: (_, state) {
          final lat = double.tryParse(state.uri.queryParameters['lat'] ?? '');
          final lng = double.tryParse(state.uri.queryParameters['lng'] ?? '');
          return MapScreen(initialLat: lat, initialLng: lng);
        },
      ),
    ],
  );
}

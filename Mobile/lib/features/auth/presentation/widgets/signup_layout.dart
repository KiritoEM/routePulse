import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_pulse_mobile/core/constants/router_constant.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';
import 'package:route_pulse_mobile/shared/widgets/progress_bar.dart';

class SignupLayout extends StatelessWidget {
  final Widget child;

  SignupLayout({super.key, required this.child});

  final List<Map<String, String>> signupRoutes = [
    {'route': RouterConstant.SIGNUP_STEP1_ROUTE},
    {'route': RouterConstant.SIGNUP_STEP2_ROUTE},
    {'route': RouterConstant.SIGNUP_STEP3_ROUTE},
  ];

  int currentRouteIndex(BuildContext context) {
    final String currRoute = GoRouterState.of(context).uri.path.toString();

    final currIndex = signupRoutes.indexWhere(
      (route) => currRoute == route['route'],
    );

    if (currIndex != -1) {
      return currIndex;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        titleSpacing: 4,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            context.canPop()
                ? context.pop(true)
                : context.go(RouterConstant.LOGIN_ROUTE);
          },
          icon: CustomIcon(path: 'assets/icons/chevron-left.svg', width: 28),
        ),
        title: Text(
          'Créer un compte',
          style: TextStyle(fontSize: AppTypography.h5, fontWeight: .w500),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 5),

          ProgressBar(activeIndex: currentRouteIndex(context)),

          Expanded(child: SafeArea(child: child)),
        ],
      ),
    );
  }
}

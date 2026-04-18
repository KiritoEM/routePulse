import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_pulse_mobile/core/constants/router_constants.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';
import 'package:route_pulse_mobile/shared/widgets/progress_bar.dart';

class SignupLayout extends StatefulWidget {
  final Widget child;

  const SignupLayout({super.key, required this.child});

  @override
  State<SignupLayout> createState() => _SignupLayoutState();
}

class _SignupLayoutState extends State<SignupLayout> {
  final List<Map<String, String>> signupRoutes = [
    {'route': RouterConstant.SIGNUP_STEP1_ROUTE},
    {'route': RouterConstant.SIGNUP_STEP2_ROUTE},
  ];

  int get currentRouteIndex {
    final String currRoute = GoRouterState.of(context).uri.toString();

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

          ProgressBar(activeIndex: currentRouteIndex),

          Expanded(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: widget.child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

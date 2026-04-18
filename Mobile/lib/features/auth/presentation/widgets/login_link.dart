import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_pulse_mobile/core/constants/router_constants.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';

class LoginLink extends StatelessWidget {
  const LoginLink({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Vous avez déja un compte?',
        style: TextStyle(
          color: AppColors.foreground,
          fontSize: AppTypography.body,
        ),
        children: [
          TextSpan(
            text: '  Se connecter',
            style: TextStyle(fontWeight: .w600, color: AppColors.info),
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.go(RouterConstant.LOGIN_ROUTE),
          ),
        ],
      ),
    );
  }
}

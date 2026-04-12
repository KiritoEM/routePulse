import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/features/auth/presentation/widgets/linear_bg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:route_pulse_mobile/features/auth/presentation/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      extendBody: true,
      body: Stack(
        children: [
          AuthLinearBg(),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                isKeyboardVisible
                    ? MediaQuery.of(context).size.height * 0.12
                    : MediaQuery.of(context).size.height * 0.025,
                16,
                MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: .max,
                mainAxisAlignment: .end,
                spacing: 24,
                children: [
                  // Header
                  Column(
                    mainAxisAlignment: .center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/route_pulse-logo.svg',
                        semanticsLabel: 'Logo RoutePulse',
                        width: 175,
                      ),

                      const SizedBox(height: 16),

                      Text(
                        "Se connecter à votre compte",
                        style: TextStyle(
                          fontSize: AppTypography.h3 - 1.5,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                        textAlign: .center,
                      ),
                    ],
                  ),

                  // Form
                  LoginForm(),

                  // Signup link
                  RichText(
                    text: TextSpan(
                      text: 'Vous n’avez pas encore de compte?',
                      style: TextStyle(
                        color: AppColors.foreground,
                        fontSize: AppTypography.body,
                      ),
                      children: [
                        TextSpan(
                          text: ' S\'inscrire',
                          style: TextStyle(
                            fontWeight: .w600,
                            color: AppColors.info,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

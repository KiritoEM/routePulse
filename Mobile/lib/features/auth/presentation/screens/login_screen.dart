import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/features/auth/presentation/widgets/linear_bg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:route_pulse_mobile/features/auth/presentation/widgets/login_form.dart';
import 'package:route_pulse_mobile/features/auth/presentation/widgets/signup_link.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      extendBody: true,
      body: Stack(
        children: [
          const AuthLinearBg(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.075,
                          ),

                          // header
                          Column(
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
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          const LoginForm(),

                          const SizedBox(height: 32),

                          const SignupLink(),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

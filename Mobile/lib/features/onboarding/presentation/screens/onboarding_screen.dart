import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/features/onboarding/presentation/models/slider_model.dart';
import 'package:route_pulse_mobile/features/onboarding/presentation/widgets/onboarding_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // data for onboarding slider
    final List<SliderModel> slides = [
      SliderModel(
        title: 'Gérez facilement\n vos livraison',
        description:
            'Organisez toutes vos livraisons en un seul endroit avec une interface simple et intuitive',
        backgroundPath: 'assets/images/onboarding-step1-bg.png',
      ),
      SliderModel(
        title: 'Optimisez vos\n trajets de livraison',
        description:
            'Visualisez votre itinéraire sur une carte et optimisez vos arrêts pour réduire le temps de trajet',
        backgroundPath: 'assets/images/onboarding-step2-bg.png',
      ),
      SliderModel(
        title: 'Analysez vos performances',
        description:
            'Consultez vos statistiques pour suivre vos performances et améliorer votre efficacité au quotidien.',
        backgroundPath: 'assets/images/onboarding-step3-bg.png',
      ),
    ];
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Stack(
          children: [
            OnboardingSlider(slides: slides, onComplete: () {}),

            Positioned.fill(
              top: 35,
              child: Align(
                alignment: .topCenter,
                child: SvgPicture.asset(
                  'assets/icons/route_pulse-logo.svg',
                  semanticsLabel: 'Logo RoutePulse',
                  width: 165,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

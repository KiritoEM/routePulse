import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/features/onboarding/presentation/models/slider_model.dart';

class OnboardingSlider extends StatefulWidget {
  final List<SliderModel> slides;
  final VoidCallback onComplete;

  const OnboardingSlider({
    super.key,
    required this.slides,
    required this.onComplete,
  });

  @override
  State<OnboardingSlider> createState() => _OnboardingSliderState();
}

class _OnboardingSliderState extends State<OnboardingSlider> {
  int _currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePressNext() {
    if (_currentIndex < widget.slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                widget.slides[_currentIndex].backgroundPath,
                fit: .cover,
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: .max,
              children: [
                Expanded(
                  child: PageView(
                    controller: _controller,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    children: widget.slides.map((slide) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 16,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              slide.title,
                              style: TextStyle(
                                fontSize: AppTypography.h2 - 1.5,
                                fontWeight: FontWeight.w500,
                                height: 1.1,
                              ),
                            ),

                            const SizedBox(height: 16),

                            Text(
                              slide.description,
                              style: const TextStyle(
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.slides.length,
                    (index) => _buildDot(isActive: index == _currentIndex),
                  ),
                ),

                const SizedBox(height: 32),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: _handlePressNext,
                        child: Text(
                          _currentIndex == 0
                              ? 'Se lancer'
                              : _currentIndex == widget.slides.length - 1
                              ? 'Commencer'
                              : 'Continuer',
                        ),
                      ),

                      const SizedBox(height: 8),

                      if (_currentIndex != widget.slides.length - 1)
                        TextButton(
                          onPressed: () => widget.onComplete(),
                          child: const Text('Passer'),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 8.5),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot({bool isActive = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      height: 6,
      width: isActive ? 30 : 12,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isActive ? AppColors.primary : Colors.grey[300],
      ),
    );
  }
}

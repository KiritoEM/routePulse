import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/add_articles_section.dart';
import 'package:route_pulse_mobile/shared/widgets/stepper_header.dart';

class AddArticles extends StatelessWidget {
  const AddArticles({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: .none,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 24),
          StepperHeader(
            title: 'Articles à livrer',
            description: Text(
              'Ajoutez les articles concernés et précisez les informations associées',
              style: TextStyle(
                color: AppColors.mutedForeground,
                fontSize: AppTypography.body,
              ),
            ),
          ),

          const SizedBox(height: 32),

          AddArticlesSection(),
        ],
      ),
    );
  }
}

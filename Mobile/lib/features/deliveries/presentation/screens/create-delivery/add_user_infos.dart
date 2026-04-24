import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/add_user_infos_form.dart';
import 'package:route_pulse_mobile/shared/widgets/stepper_header.dart';

class AddUserInfos extends StatelessWidget {
  const AddUserInfos({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),
          StepperHeader(
            title: 'Entrez les informations du client',
            description: Text(
              'Renseignez les informations nécessaires pour identifier le client',
              style: TextStyle(
                color: AppColors.mutedForeground,
                fontSize: AppTypography.body,
              ),
            ),
          ),

          const SizedBox(height: 32),

          AddUserInfosForm(),
        ],
      ),
    );
  }
}

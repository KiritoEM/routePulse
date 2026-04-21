import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/deliveries_appbar.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/status_filter.dart';
import 'package:route_pulse_mobile/shared/widgets/app_bottom_navigation.dart';

class DeliveriesScreen extends StatelessWidget {
  const DeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayBg,
      appBar: DeliveriesAppbar(),
      body: Column(
        children: [
          const SizedBox(height: 16),

          StatusFilter(selectedStatus: 'all', onSelect: (String value) {}),
          Expanded(
            child: Center(child: Text('Contenu des livraisons à venir')),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavigation(),
    );
  }
}

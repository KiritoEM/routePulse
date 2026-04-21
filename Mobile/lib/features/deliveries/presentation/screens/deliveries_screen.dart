import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/deliveries_appbar.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/delivery_card.dart';
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

          const SizedBox(height: 32),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: ListView.separated(
                itemCount: 2,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return DeliveryCard(
                    deliveryId: '#ORD-260425',
                    status: DeliveryStatus.inProgress, 
                    timeSlotStart: '12:00',
                    timeSlotEnd: '15:00',
                    clientName: 'Jenny Wilson',
                    city: 'Ankorondrano',
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavigation(),
    );
  }
}

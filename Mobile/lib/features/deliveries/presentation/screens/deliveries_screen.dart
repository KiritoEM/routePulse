import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/notifiers/deliveries_list_notifier.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/deliveries_appbar.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/delivery_card.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/status_filter.dart';
import 'package:route_pulse_mobile/shared/widgets/app_bottom_navigation.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

class DeliveriesScreen extends ConsumerWidget {
  const DeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveriesListState = ref.watch(deliveriesListProvider);

    return Scaffold(
      backgroundColor: AppColors.grayBg,
      appBar: DeliveriesAppbar(),
      body: switch (deliveriesListState) {
        HttpInitial() ||
        HttpLoading() => const Center(child: CircularProgressIndicator()),
        HttpError(:final message) => Center(child: Text(message)),
        HttpSuccess(:final data) => Column(
          children: [
            const SizedBox(height: 16),
            StatusFilter(selectedStatus: 'all', onSelect: (String value) {}),
            const SizedBox(height: 32),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.separated(
                  itemCount: data?.length ?? 0,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final delivery = data[index];
                    return DeliveryCard(
                      deliveryId: delivery.id,
                      status: delivery.status,
                      timeSlotStart: delivery.timeSlotStart,
                      timeSlotEnd: delivery.timeSlotEnd,
                      clientName: delivery.clientName,
                      city: delivery.city,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        _ => const SizedBox.shrink(),
      },
      bottomNavigationBar: AppBottomNavigation(),
    );
  }
}

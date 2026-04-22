import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/notifiers/deliveries_filter_notifier.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/notifiers/deliveries_list_notifier.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/deliveries_appbar.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/deliveries_list_skeleton.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/delivery_card.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/empty_deliveries.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/filter_bottomsheet.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/status_filter.dart';
import 'package:route_pulse_mobile/shared/widgets/app_bottom_navigation.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

class DeliveriesScreen extends ConsumerWidget {
  const DeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveriesListState = ref.watch(deliveriesListProvider);
    final deliveriesFilterState = ref.watch(deliveriesFilterProvider);
    final deliveriesFilterVm = ref.read(deliveriesFilterProvider.notifier);
    final DeliveryStatus currentStatus = deliveriesFilterState['status'];

    return Scaffold(
      backgroundColor: AppColors.grayBg,
      appBar: DeliveriesAppbar(
        onFilter: () {
          FilterBottomsheet.show(
            context,
            deliveriesFilterState['sort'],
            (SortFilterEnum? sortFilter) {
              deliveriesFilterVm.setFilter(sort: sortFilter);
            },
            () {
              deliveriesFilterVm.setFilter(sort: null);
            },
          );
        },
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          StatusFilter(
            selectedStatus: currentStatus,
            onSelect: (DeliveryStatus status) {
              deliveriesFilterVm.setFilter(status: status);
            },
          ),
          const SizedBox(height: 32),
          Expanded(child: _buildBody(deliveriesListState, currentStatus)),
        ],
      ),
      bottomNavigationBar: AppBottomNavigation(),
    );
  }

  Widget _buildBody(dynamic deliveriesListState, DeliveryStatus currentStatus) {
    return switch (deliveriesListState) {
      HttpInitial() || HttpLoading() => const DeliveriesListSkeleton(),
      HttpError(:final message) => Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.error),
        ),
      ),
      HttpSuccess(:final data) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: data.isEmpty
            ? EmptyDeliveries(isFiltered: currentStatus != DeliveryStatus.all)
            : ListView.separated(
                itemCount: data.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final delivery = data[index];
                  return DeliveryCard(
                    deliveryId: delivery.deliveryId,
                    status: delivery.status,
                    timeSlotStart: delivery.timeSlotStart,
                    timeSlotEnd: delivery.timeSlotEnd,
                    clientName: delivery.client.name,
                    city: delivery.city,
                  );
                },
              ),
      ),
      _ => const SizedBox.shrink(),
    };
  }
}

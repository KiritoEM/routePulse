import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:route_pulse_mobile/core/constants/router_constant.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/features/deliveries/domain/entities/delivery.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/delivery_card.dart';
import 'package:route_pulse_mobile/features/home/presentation/notifiers/deliveries_pending_notifier.dart';
import 'package:route_pulse_mobile/features/home/presentation/widgets/deliveries_pending_skeleton.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';

class NextDeliveriesSection extends ConsumerWidget {
  const NextDeliveriesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveriesPendingState = ref.watch(deliveriesPendingProvider);

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            spacing: 8,
            mainAxisAlignment: .spaceBetween,
            crossAxisAlignment: .center,
            children: [
              Text(
                'Livraisons en attente',
                style: TextStyle(fontSize: AppTypography.h5),
              ),

              IntrinsicWidth(
                child: TextButton(
                  onPressed: () => context.go(RouterConstant.DELIVERIES_ROUTE),
                  child: Text(
                    'Voir tout',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: .w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          switch (deliveriesPendingState) {
            HttpInitial() || HttpLoading() => SizedBox(
              width: double.infinity,
              child: DeliveriesPendingSkeleton(),
            ),
            HttpError(:final message) => Center(
              child: Text(message, style: TextStyle(color: AppColors.error)),
            ),
            HttpSuccess(:final data as List<Delivery>) =>
              data.isEmpty
                  ? _buildEmptyDeliveries()
                  : Column(
                      children: data
                          .map<Widget>(
                            (item) => DeliveryCard(
                              id: item.id,
                              deliveryId: item.deliveryId,
                              status: item.status,
                              timeSlotStart: item.timeSlotStart,
                              timeSlotEnd: item.timeSlotEnd,
                              clientName: item.client.name,
                            ),
                          )
                          .toList(),
                    ),
            _ => const SizedBox.shrink(),
          },
        ],
      ),
    );
  }

  Widget _buildEmptyDeliveries() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 24),

          Container(
            decoration: BoxDecoration(
              color: AppColors.Primary100,
              borderRadius: BorderRadius.circular(50),
            ),
            padding: EdgeInsets.all(16),
            child: CustomIcon(
              path: 'assets/icons/package-filled.svg',
              width: 40,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Aucune livraison en attente',
            style: TextStyle(
              fontSize: AppTypography.body,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),

          Text(
            'Les prochaines livraisons apparaîtront ici',
            style: TextStyle(
              fontSize: AppTypography.small,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

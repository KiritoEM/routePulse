import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/constants/router_constant.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:route_pulse_mobile/core/utils/app_toast.dart';
import 'package:route_pulse_mobile/core/utils/string_utils.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/notifiers/deliveries_list_notifier.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/notifiers/start_delivery_notifier.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/notifiers/validate_delivery_notifier.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/delivery_actions_bottomhsheet.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';

class DeliveryCard extends ConsumerWidget {
  final String id;
  final String deliveryId;
  final DeliveryStatus status;
  final String timeSlotStart;
  final String timeSlotEnd;
  final String clientName;
  final String? city;

  const DeliveryCard({
    super.key,
    required this.id,
    required this.deliveryId,
    required this.status,
    required this.timeSlotStart,
    required this.timeSlotEnd,
    required this.clientName,
    this.city,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(startDeliveryProvider, (previous, next) {
      if (previous is HttpLoading && next is HttpSuccess) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            AppToast.success(context, 'Livraison démarrée avec succès');
            ref.read(deliveriesListProvider.notifier).refetch();
          }
        });
      }
      if (next is HttpError) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            AppToast.error(context, next.message);
          }
        });
      }
    });

    return GestureDetector(
      onTap: () => context.go('${RouterConstant.DELIVERY_DETAILS}/$id'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 14,
                  ),
                  decoration: BoxDecoration(
                    color: status.color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status.label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppTypography.small,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => DeliveryActionsBottomsheet().show(
                    context,
                    deliveryId: id,
                    onStart: () =>
                        ref.read(startDeliveryProvider.notifier).submit(id),
                    showStartAction:
                        status.value == DeliveryStatus.pending.value,
                    showValidateAction:
                        status.value == DeliveryStatus.inProgress.value,
                    showReportAction:
                        status.value != DeliveryStatus.delivered.value &&
                        status.value != DeliveryStatus.cancelled.value,
                  ),
                  icon: const Icon(Icons.more_vert_sharp),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(deliveryId, style: TextStyle(fontSize: AppTypography.h5)),
            const SizedBox(height: 22),
            DottedLine(
              direction: Axis.horizontal,
              lineLength: double.infinity,
              dashLength: 7.0,
              dashGapLength: 5.0,
              dashColor: AppColors.border,
            ),
            const SizedBox(height: 22),
            Wrap(
              spacing: 20,
              runSpacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIcon(
                      path: 'assets/icons/clock.svg',
                      width: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${StringUtils.formatTime(timeSlotStart)} - ${StringUtils.formatTime(timeSlotEnd)}',
                      style: TextStyle(fontSize: AppTypography.body),
                    ),
                  ],
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIcon(
                      path: 'assets/icons/profile.svg',
                      width: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      clientName,
                      style: TextStyle(fontSize: AppTypography.body),
                    ),
                  ],
                ),

                if (city != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIcon(
                        path: 'assets/icons/location.svg',
                        width: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        city!,
                        style: TextStyle(fontSize: AppTypography.body),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

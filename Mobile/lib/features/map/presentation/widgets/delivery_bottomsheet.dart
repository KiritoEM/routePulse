import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_pulse_mobile/core/constants/router_constant.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/core/utils/string_utils.dart';
import 'package:route_pulse_mobile/features/deliveries/domain/entities/delivery.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/client_list_title.dart';
import 'package:route_pulse_mobile/shared/widgets/app_bottomsheet.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';

class DeliveryBottomsheet {
  static Future<void> show(BuildContext context, Delivery delivery) {
    return AppBottomSheet.show(
      context: context,
      builder: (sheetContext, setModalState) {
        return [
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              spacing: 28,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 16,
                  children: [
                    Expanded(
                      child: Text(
                        delivery.deliveryId,
                        style: TextStyle(fontSize: AppTypography.h5),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 14,
                      ),
                      decoration: BoxDecoration(
                        color: delivery.status.color,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        delivery.status.label,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppTypography.small + 1.5,
                        ),
                      ),
                    ),
                  ],
                ),

                // details
                Column(
                  spacing: 16,
                  children: [
                    _buildField(
                      icon: 'assets/icons/location.svg',
                      title: 'Lieu',
                      value: delivery.city!,
                    ),

                    _buildField(
                      icon: 'assets/icons/location.svg',
                      title: 'adresse',
                      value: delivery.address,
                    ),

                    _buildField(
                      icon: 'assets/icons/clock.svg',
                      title: 'creneau',
                      value:
                          '${StringUtils.formatTime(delivery.timeSlotStart)} - ${StringUtils.formatTime(delivery.timeSlotEnd)}',
                    ),

                    if (delivery.notes != null)
                      _buildField(
                        icon: 'assets/icons/note.svg',
                        title: 'notes',
                        value: delivery.notes!,
                      ),
                  ],
                ),

                DottedLine(
                  direction: .horizontal,
                  alignment: .center,
                  lineLength: double.infinity,
                  dashLength: 7.0,
                  dashGapLength: 5.0,
                  dashColor: AppColors.border,
                ),

                ClientListTitle(
                  name: delivery.client.name,
                  phoneNumber: delivery.client.phoneNumber,
                ),

                ElevatedButton(
                  onPressed: () => context.go(
                    '${RouterConstant.DELIVERY_DETAILS}/${delivery.id}',
                  ),
                  child: Text('Voir la livraison'),
                ),
              ],
            ),
          ),
        ];
      },
    );
  }

  static Widget _buildField({
    required String icon,
    required String title,
    required String value,
  }) {
    return Column(
      spacing: 8,
      crossAxisAlignment: .start,
      children: [
        Row(
          spacing: 8,
          children: [
            CustomIcon(path: icon, width: 20, color: AppColors.primary),

            Text(
              title.toUpperCase(),
              style: TextStyle(color: AppColors.mutedForeground),
            ),
          ],
        ),

        Text(value),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';

class DeliveryCard extends StatelessWidget {
  final String deliveryId;
  final DeliveryStatus status;
  final String timeSlotStart;
  final String timeSlotEnd;
  final String clientName;
  final String city;

  const DeliveryCard({
    super.key,
    required this.deliveryId,
    required this.status,
    required this.timeSlotStart,
    required this.timeSlotEnd,
    required this.clientName,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(.circular(14)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            crossAxisAlignment: .start,
            children: [
              // badge
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
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

              // action
              IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_sharp)),
            ],
          ),

          const SizedBox(height: 8),

          Text(deliveryId, style: TextStyle(fontSize: AppTypography.h5)),

          const SizedBox(height: 24),

          DottedLine(
            direction: .horizontal,
            alignment: .center,
            lineLength: double.infinity,
            dashLength: 7.0,
            dashGapLength: 5.0,
            dashColor: AppColors.border,
          ),

          const SizedBox(height: 24),

          Wrap(
            spacing: 20,
            runSpacing: 12,
            direction: .horizontal,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  CustomIcon(
                    path: 'assets/icons/clock.svg',
                    width: 18,
                    color: AppColors.primary,
                  ),

                  Text(
                    '$timeSlotStart-$timeSlotEnd',
                    style: TextStyle(fontSize: AppTypography.body),
                  ),
                ],
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  CustomIcon(
                    path: 'assets/icons/profile.svg',
                    width: 18,
                    color: AppColors.primary,
                  ),

                  Text(
                    clientName,
                    style: TextStyle(fontSize: AppTypography.body),
                  ),
                ],
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  CustomIcon(
                    path: 'assets/icons/location.svg',
                    width: 18,
                    color: AppColors.primary,
                  ),

                  Text(city, style: TextStyle(fontSize: AppTypography.body)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

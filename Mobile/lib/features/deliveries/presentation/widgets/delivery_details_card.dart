import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/utils/string_utils.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/client_list_title.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';

class DeliveryDetailsCard extends StatelessWidget {
  final String address;
  final String timeSlotStart;
  final String timeSlotEnd;
  final String? notes;
  final String clientName;
  final String phoneNumber;

  const DeliveryDetailsCard({
    super.key,
    required this.address,
    required this.timeSlotStart,
    required this.timeSlotEnd,
    this.notes,
    required this.clientName,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: EdgeInsets.all(24),
      child: Column(
        spacing: 24,
        children: [
          _buildField(
            icon: 'assets/icons/location.svg',
            title: 'adresse',
            value: address,
          ),
          _buildField(
            icon: 'assets/icons/clock.svg',
            title: 'creneau',
            value:
                '${StringUtils.formatTime(timeSlotStart)} - ${StringUtils.formatTime(timeSlotEnd)}',
          ),

          if (notes != null)
            _buildField(
              icon: 'assets/icons/note.svg',
              title: 'notes',
              value: notes!,
            ),

          DottedLine(
            direction: .horizontal,
            alignment: .center,
            lineLength: double.infinity,
            dashLength: 7.0,
            dashGapLength: 5.0,
            dashColor: AppColors.border,
          ),

          ClientListTitle(name: clientName, phoneNumber: phoneNumber),
        ],
      ),
    );
  }

  Widget _buildField({
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

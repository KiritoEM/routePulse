import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';

class SummaryCard extends StatelessWidget {
  final String clientName;
  final String address;
  final String timeSlot;
  final int totalPrice;

  const SummaryCard({
    super.key,
    required this.clientName,
    required this.address,
    required this.timeSlot,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text('Récapitulatif', style: TextStyle(fontSize: AppTypography.h5)),

          const SizedBox(height: 20),

          Column(
            spacing: 16,
            children: [
              _buildSummaryField(title: 'client', value: clientName),
              _buildSummaryField(title: 'adresse', value: address),
              _buildSummaryField(title: 'créneau', value: timeSlot),
              _buildSummaryField(title: 'prix total', value: '$totalPrice Ar'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryField({required String title, required String value}) {
    return Row(
      spacing: 8,
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(color: AppColors.mutedForeground),
        ),

        Text(value),
      ],
    );
  }
}

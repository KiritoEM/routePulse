import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';

class StatusFilter extends StatelessWidget {
  final DeliveryStatus selectedStatus;
  final Function(DeliveryStatus status) onSelect;

  const StatusFilter({
    super.key,
    required this.selectedStatus,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: DeliveryStatus.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final filter = DeliveryStatus.values[index];
          // print('filter: $filter | selectedValue: $selectedStatus');
          final bool isSelected = selectedStatus == filter;

          return FilterChip(
            label: Text(
              filter.label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.foreground,
              ),
            ),
            selectedColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            selected: isSelected,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: Colors.transparent, width: 0),
            ),
            showCheckmark: false,
            onSelected: (selected) {
              if (selected) {
                onSelect(filter);
              }
            },
          );
        },
      ),
    );
  }
}

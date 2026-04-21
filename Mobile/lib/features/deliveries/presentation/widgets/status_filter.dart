import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';

class StatusFilter extends StatelessWidget {
  final String selectedStatus;
  final Function(String value) onSelect;

  StatusFilter({
    super.key,
    required this.selectedStatus,
    required this.onSelect,
  });

  final List<Map<String, String>> filterData = [
    {'label': 'Toutes', 'value': 'all'},
    {'label': 'En cours', 'value': 'in_progress'},
    {'label': 'Livrées', 'value': 'delivered'},
    {'label': 'À reporter', 'value': 'reported'},
    {'label': 'Annulée', 'value': 'cancelled'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filterData.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final filter = filterData[index];
          final bool isSelected = selectedStatus == filter['value'];

          return FilterChip(
            label: Text(
              filter['label']!,
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
                onSelect(filter['value']!);
              }
            },
          );
        },
      ),
    );
  }
}

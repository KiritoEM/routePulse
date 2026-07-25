import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/shared/widgets/app_bottomsheet.dart';

class FilterBottomsheet {
  static Future show(
    BuildContext context,
    SortFilterEnum? sortFilter,
    PeriodFilterEnum? periodFilter,
    Function(SortFilterEnum? sortFilter, PeriodFilterEnum? periodFilter)
    onApply,
    VoidCallback onReset,
  ) async {
    const List<Map<String, dynamic>> sortFilterData = [
      {'value': SortFilterEnum.creationDate, 'label': 'Date de création'},
      {'value': SortFilterEnum.timeSlot, 'label': 'Créneau horaire'},
    ];
    SortFilterEnum? selectedFilter = sortFilter;
    PeriodFilterEnum? selectedPeriod = periodFilter;

    return await AppBottomSheet.show(
      context: context,
      builder: (context, setModalState) {
        return [
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filtres',
                      style: TextStyle(fontSize: AppTypography.h5),
                    ),

                    IntrinsicWidth(
                      child: OutlinedButton(
                        onPressed: () {
                          setModalState(() {
                            onReset();
                            Navigator.pop(context);
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(width: 1.0, color: AppColors.error),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          'Effacer',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionLabel('Période'),
                    const SizedBox(height: 4),
                    RadioGroup<PeriodFilterEnum>(
                      groupValue: selectedPeriod,
                      onChanged: (PeriodFilterEnum? value) {
                        setModalState(() {
                          selectedPeriod = value;
                        });
                      },
                      child: Column(
                        children: PeriodFilterEnum.values.map((opt) {
                          return _buildOption<PeriodFilterEnum>(
                            label: opt.label,
                            value: opt,
                            onTap: () {
                              setModalState(() {
                                selectedPeriod = opt;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionLabel('Trier par'),
                    const SizedBox(height: 4),
                    RadioGroup<SortFilterEnum>(
                      groupValue: selectedFilter,
                      onChanged: (SortFilterEnum? value) {
                        setModalState(() {
                          selectedFilter = value;
                        });
                      },
                      child: Column(
                        children: sortFilterData.map((opt) {
                          return _buildOption<SortFilterEnum>(
                            label: opt['label'],
                            value: opt['value'],
                            onTap: () {
                              setModalState(() {
                                selectedFilter = opt['value'];
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      onApply(selectedFilter, selectedPeriod);
                      Navigator.pop(context);
                    },
                    child: Text('Appliquer'),
                  ),
                ),
              ],
            ),
          ),
        ];
      },
    );
  }

  static Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: TextStyle(color: AppColors.mutedForeground, fontSize: 15),
    );
  }

  static Widget _buildOption<T>({
    required String label,
    required T value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(label, style: TextStyle(fontSize: AppTypography.body)),
            Radio<T>(
              value: value,
              activeColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              side: BorderSide(color: AppColors.mutedForeground),
            ),
          ],
        ),
      ),
    );
  }
}

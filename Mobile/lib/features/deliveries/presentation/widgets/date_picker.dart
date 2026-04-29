import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/utils/date_utils.dart';
import 'package:route_pulse_mobile/shared/widgets/tappable_field.dart';

class DatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final bool hasError;
  final void Function(DateTime? date) onPickDate;

  const DatePicker({
    super.key,
    this.selectedDate,
    required this.hasError,
    required this.onPickDate,
  });

  @override
  Widget build(BuildContext context) {

   Future<void> _pickDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    onPickDate(picked);
  }

    return TappableField(
      text: selectedDate != null
          ? CustomDateUtils.formatDate(selectedDate!)
          : 'jj/mm/aa',
      hasValue: selectedDate != null,
      suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
      hasError: hasError,
      onTap: _pickDate,
    );
  }
}

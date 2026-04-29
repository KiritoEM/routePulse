import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/utils/date_utils.dart';
import 'package:route_pulse_mobile/shared/widgets/tappable_field.dart';

class TimeSlotPicker extends StatelessWidget {
  final TimeOfDay? timeSlotStart;
  final TimeOfDay? timeSlotEnd;
  final bool hasError;
  final void Function(TimeOfDay? time) pickStartTime;
  final void Function(TimeOfDay? time) pickEndTime;

  const TimeSlotPicker({
    super.key,
    this.timeSlotStart,
    this.timeSlotEnd,
    required this.hasError,
    required this.pickStartTime,
    required this.pickEndTime,
  });

  @override
  Widget build(BuildContext context) {
    Future<void> pickTime({required bool isStart}) async {
      final initial = isStart
          ? (timeSlotStart ?? TimeOfDay.fromDateTime(DateTime.now()))
          : (timeSlotEnd ?? const TimeOfDay(hour: 12, minute: 30));

      final picked = await showTimePicker(
        context: context,
        initialTime: initial,
      );

      if (picked != null) {
        if (isStart) {
          pickStartTime(picked);
        } else {
          pickEndTime(picked);
        }
      }
    }

    return Row(
      children: [
        Expanded(
          child: TappableField(
            text: timeSlotStart != null
                ? CustomDateUtils.formatTime(timeSlotStart!)
                : '00:00',
            hasValue: timeSlotStart != null,
            hasError: hasError,
            onTap: () => pickTime(isStart: true),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            width: 25,
            height: 2,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),

        Expanded(
          child: TappableField(
            text: timeSlotEnd != null
                ? CustomDateUtils.formatTime(timeSlotEnd!)
                : '00:00',
            hasValue: timeSlotEnd != null,
            hasError: hasError,
            onTap: () => pickTime(isStart: false),
          ),
        ),
      ],
    );
  }
}

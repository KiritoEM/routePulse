import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/core/utils/app_toast.dart';
import 'package:route_pulse_mobile/core/utils/date_utils.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/notifiers/report_delivery_notifier.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/date_picker.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/widgets/app_bottomsheet.dart';
import 'package:route_pulse_mobile/shared/widgets/button_with_loader.dart';
import 'package:route_pulse_mobile/shared/widgets/error_text.dart';
import 'package:route_pulse_mobile/shared/widgets/labeled_field.dart';
import 'package:route_pulse_mobile/shared/widgets/time_slot_picker.dart';

class ReportDeliveryBottomsheet {
  Future show(BuildContext context, String deliveryId) {
    DateTime? selectedDate;
    TimeOfDay? timeSlotStart;
    TimeOfDay? timeSlotEnd;

    final dateKey = GlobalKey<FormFieldState>();
    final timeSlotKey = GlobalKey<FormFieldState>();

    void handleSubmit(WidgetRef ref) {
      final isDateValid = dateKey.currentState!.validate();
      final isTimeSlotValid = timeSlotKey.currentState!.validate();

      if (!isDateValid || !isTimeSlotValid) {
        return;
      }

      ref
          .read(reportDeliveryProvider.notifier)
          .submit(
            deliveryId,
            selectedDate!.toIso8601String(),
            timeSlotStart: CustomDateUtils.formatTime(timeSlotStart!),
            timeSlotEnd: CustomDateUtils.formatTime(timeSlotEnd!),
          );
    }

    return AppBottomSheet.show(
      context: context,
      builder: (sheetContext, setModalState) {
        return [
          Consumer(
            builder: (context, ref, child) {
              final state = ref.watch(reportDeliveryProvider);

              ref.listen(reportDeliveryProvider, (previous, next) {
                if (previous is HttpLoading && next is HttpSuccess) {
                  AppToast.success(context, next.message!);
                  if (sheetContext.mounted) {
                    Navigator.pop(sheetContext, true);
                  }
                  return;
                }

                if (next is HttpError) {
                  AppToast.error(context, next.message);
                }
              });

              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'Reporter la livraison',
                        style: TextStyle(fontSize: AppTypography.h5),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 24),

                    LabeledField(
                      label: 'Nouvelle date de livraison',
                      children: FormField<DateTime>(
                        key: dateKey,
                        validator: (_) => _validateDate(selectedDate),
                        builder: (field) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DatePicker(
                              selectedDate: selectedDate ?? DateTime.now(),
                              hasError: field.hasError,
                              onPickDate: (DateTime? date) {
                                if (date != null && context.mounted) {
                                  setModalState(() => selectedDate = date);
                                  field.didChange(date);

                                  // slot validity depends on the picked date
                                  timeSlotKey.currentState?.validate();
                                }
                              },
                            ),
                            if (field.hasError) ErrorText(field.errorText!),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    LabeledField(
                      label: 'Nouveau créneau horaire',
                      children: FormField<bool>(
                        key: timeSlotKey,
                        validator: (_) => _validateTimeSlot(
                          selectedDate,
                          timeSlotStart,
                          timeSlotEnd,
                        ),
                        builder: (field) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TimeSlotPicker(
                              timeSlotStart: timeSlotStart,
                              timeSlotEnd: timeSlotEnd,
                              hasError: field.hasError,
                              pickStartTime: (time) {
                                setModalState(() => timeSlotStart = time);
                                field.didChange(true);
                              },
                              pickEndTime: (time) {
                                setModalState(() => timeSlotEnd = time);
                                field.didChange(true);
                              },
                            ),
                            if (field.hasError) ErrorText(field.errorText!),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    ButtonWithLoader(
                      text: 'Confirmation',
                      isLoading: state is HttpLoading,
                      loadingText: '',
                      onPressed: state is HttpLoading
                          ? null
                          : () => handleSubmit(ref),
                    ),
                  ],
                ),
              );
            },
          ),
        ];
      },
    );
  }

  String? _validateDate(DateTime? date) {
    if (date == null) return 'Veuillez sélectionner une date';

    final today = DateTime.now();
    final pickedDay = DateTime(date.year, date.month, date.day);
    final currentDay = DateTime(today.year, today.month, today.day);

    if (pickedDay.isBefore(currentDay)) {
      return 'La date doit être aujourd\'hui ou après';
    }

    return null;
  }

  String? _validateTimeSlot(
    DateTime? date,
    TimeOfDay? start,
    TimeOfDay? end,
  ) {
    if (start == null || end == null) {
      return 'Veuillez définir un créneau horaire';
    }

    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    if (endMinutes <= startMinutes) {
      return 'L\'heure de fin doit être après l\'heure de début';
    }

    if (date == null) return null;

    // slot must still be ahead when reported on the same day
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    if (isToday && startMinutes <= now.hour * 60 + now.minute) {
      return 'Le créneau doit être après l\'heure actuelle';
    }

    return null;
  }
}

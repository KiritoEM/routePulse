import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/core/utils/app_toast.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/notifiers/report_delivery_notifier.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/date_picker.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/widgets/app_bottomsheet.dart';
import 'package:route_pulse_mobile/shared/widgets/button_with_loader.dart';
import 'package:route_pulse_mobile/shared/widgets/error_text.dart';
import 'package:route_pulse_mobile/shared/widgets/labeled_field.dart';

class ReportDeliveryBottomsheet {
  Future show(BuildContext context, String deliveryId) {
    DateTime? selectedDate;
    final dateKey = GlobalKey<FormFieldState>();

    void handleSubmit(WidgetRef ref) {
      if (!dateKey.currentState!.validate()) {
        return;
      }

      dateKey.currentState!.save();

      ref
          .read(reportDeliveryProvider.notifier)
          .submit(deliveryId, selectedDate!.toIso8601String());
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
                        validator: (_) => selectedDate == null
                            ? 'Veuillez sélectionner une date'
                            : null,
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
                                }
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
}

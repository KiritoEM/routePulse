import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/core/utils/app_toast.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/notifiers/cancel_delivery_notifier.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/widgets/app_bottomsheet.dart';
import 'package:route_pulse_mobile/shared/widgets/button_with_loader.dart';
import 'package:route_pulse_mobile/shared/widgets/labeled_field.dart';

class CancelDeliveryBottomsheet {
  Future show(BuildContext context, String deliveryId) {
    final GlobalKey<FormState> formkey = GlobalKey<FormState>();
    String savedReason = '';

    void handleSubmit(WidgetRef ref) {
      if (!formkey.currentState!.validate()) {
        return;
      }

      formkey.currentState!.save();

      ref.read(cancelDeliveryProvider.notifier).submit(deliveryId, savedReason);
    }

    return AppBottomSheet.show(
      context: context,
      builder: (sheetContext, setModalState) {
        return [
          Consumer(
            builder: (context, ref, child) {
              final state = ref.watch(cancelDeliveryProvider);

              ref.listen(cancelDeliveryProvider, (previous, next) {
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
                        'Annuler la livraison',
                        style: TextStyle(fontSize: AppTypography.h5),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Form(
                      key: formkey,
                      child: Column(
                        children: [
                          LabeledField(
                            label: 'Motif',
                            children: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Ecrivez le motif ici...',
                              ),
                              minLines: 3,
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Motif obligatoire';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                if (value != null && context.mounted) {
                                  setModalState(() => savedReason = value);
                                }
                              },
                            ),
                          ),

                          const SizedBox(height: 24),

                          ButtonWithLoader(
                            text: 'Annuler',
                            isLoading: state is HttpLoading,
                            loadingText: '',
                            onPressed: state is HttpLoading
                                ? null
                                : () => handleSubmit(ref),
                          ),
                        ],
                      ),
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

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/core/utils/app_toast.dart';
import 'package:route_pulse_mobile/core/utils/date_utils.dart';
import 'package:route_pulse_mobile/core/utils/file_utils.dart';
import 'package:route_pulse_mobile/core/utils/image_picker_utils.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/notifiers/validate_delivery_notifier.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/states/create_delivery_state.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/states/validate_delivery_state.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/image_picker.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/widgets/app_bottomsheet.dart';
import 'package:route_pulse_mobile/shared/widgets/button_with_loader.dart';
import 'package:route_pulse_mobile/shared/widgets/labeled_field.dart';

class ValidateDeliveryBottomsheet {
  Future show(BuildContext context, String deliveryId) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    File? selectedImage;
    ArticleFile? articleFile;
    String deliveredAt = CustomDateUtils.formatTime(
      TimeOfDay.fromDateTime(DateTime.now()),
    );
    final TextEditingController totalKmController = TextEditingController();

    Future<void> handleUploadImage(
      BuildContext context,
      StateSetter setModalState,
    ) async {
      final pickedImageResponse = await ImagePickerUtils.pickImage();
      if (!context.mounted) return;

      if (pickedImageResponse.isSucess) {
        final file = pickedImageResponse.data['file'] as File;
        final name = pickedImageResponse.data['originalName'] as String;
        final mimeType =
            (pickedImageResponse.data['mimeType'] as String?) ?? 'image/jpeg';

        articleFile = ArticleFile(
          file: FileUtils.convertFileToBase64(file),
          originalName: name,
          mimeType: mimeType,
          size: file.lengthSync(),
        );

        setModalState(() => selectedImage = file);
        return;
      }

      AppToast.error(context, pickedImageResponse.message!);
    }

    void handleSubmit(WidgetRef ref) {
      if (!formKey.currentState!.validate()) return;
      if (articleFile == null) {
        AppToast.error(context, 'Veuillez ajouter une photo de preuve');
        return;
      }

      formKey.currentState!.save();

      final data = ValidateDeliveryState(
        file: articleFile!,
        totalKm: double.parse(totalKmController.text),
        deliveredAt: deliveredAt,
      );

      ref.read(validateDeliveryProvider.notifier).submit(deliveryId, data);
    }

    return AppBottomSheet.show(
      context: context,
      builder: (sheetContext, setModalState) {
        return [
          Consumer(
            builder: (context, ref, child) {
              final state = ref.watch(validateDeliveryProvider);

              ref.listen(validateDeliveryProvider, (previous, next) {
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
                        'Valider la livraison',
                        style: TextStyle(fontSize: AppTypography.h5),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          LabeledField(
                            label: 'Photo de preuve *',
                            children: ImagePicker(
                              image: selectedImage,
                              onTap: () => handleUploadImage(
                                sheetContext,
                                setModalState,
                              ),
                              onRemove: () {
                                if (!sheetContext.mounted) return;
                                setModalState(() {
                                  selectedImage = null;
                                  articleFile = null;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          LabeledField(
                            label: 'Kilomètres parcourus',
                            children: TextFormField(
                              controller: totalKmController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: const InputDecoration(
                                hintText: 'ex: 42',
                                suffixText: 'km',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Veuillez entrer le nombre de km';
                                }
                                final number = int.tryParse(value);
                                if (number == null || number < 0) {
                                  return 'Veuillez entrer un nombre valide';
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(height: 24),

                          ButtonWithLoader(
                            text: 'Confirmer la livraison',
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

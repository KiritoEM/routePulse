import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/core/utils/app_toast.dart';
import 'package:route_pulse_mobile/core/utils/file_utils.dart';
import 'package:route_pulse_mobile/core/utils/image_picker_utils.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/states/create_delivery_state.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/image_picker.dart';
import 'package:route_pulse_mobile/shared/widgets/app_bottomsheet.dart';
import 'package:route_pulse_mobile/shared/widgets/labeled_field.dart';

class CreateArticleBottomsheet {
  Future show(
    BuildContext context,
    WidgetRef ref,
    Function(DeliveryArticle article) onAddArticle,
  ) async {
    final GlobalKey<FormState> formkey = GlobalKey<FormState>();
    
    // article model
    DeliveryArticle article = DeliveryArticle(
      name: '',
      quantity: 1,
      price: 100,
    );
    File? selectedImage;

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

        final ArticleFile articleFile = ArticleFile(
          file: FileUtils.convertFileToBase64(file),
          originalName: name,
          mimeType: mimeType,
          size: file.lengthSync(),
        );

        article = article.copyWith(file: articleFile);

        setModalState(() => selectedImage = file);

        return;
      }

      AppToast.error(context, pickedImageResponse.message!);
    }

    return AppBottomSheet.show(
      context: context,
      builder: (sheetContext, setModalState) {
        void handleSubmit() {
          if (!formkey.currentState!.validate()) {
            return;
          }

          formkey.currentState!.save();

          onAddArticle(article);

          Navigator.pop(sheetContext);
        }

        return [
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'Ajouter un article',
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
                        label: 'Image(optionnel)',
                        children: ImagePicker(
                          image: selectedImage,
                          onTap: () =>
                              handleUploadImage(context, setModalState),
                          onRemove: () {
                            if (!sheetContext.mounted) return;

                            article = article.copyWith(file: null);

                            setModalState(() {
                              selectedImage = null;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      LabeledField(
                        label: 'Nom de l\'article',
                        children: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'ex: Jean Bleue',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Veuillez entrer le nom d\'article';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            if (value != null) {
                              article = article.copyWith(name: value);
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      LabeledField(
                        label: 'Quantité',
                        children: TextFormField(
                          initialValue: '1',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            hintText: 'Quantité de l\'article',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Veuillez entrer un nombre valide';
                            }

                            final number = int.tryParse(value);
                            if (number == null || number <= 0) {
                              return 'Veuillez entrer un nombre valide';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null) {
                              article = article.copyWith(
                                quantity: int.tryParse(value) ?? 1,
                              );
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      LabeledField(
                        label: 'Prix(Ar)',
                        children: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            hintText: 'Le prix de l\'article',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Veuillez entrer le prox de l\'article';
                            }

                            final number = int.tryParse(value);
                            if (number == null || number <= 0) {
                              return 'Veuillez entrer un nombre valide';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            if (value != null) {
                              article = article.copyWith(
                                price: double.tryParse(value) ?? 0.0,
                              );
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      ElevatedButton(
                        onPressed: () => handleSubmit(),
                        child: Text('Ajouter l\'article'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ];
      },
    );
  }
}

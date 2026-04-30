import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/core/utils/app_toast.dart';
import 'package:route_pulse_mobile/features/client/presentation/notifiers/create_client_notifier.dart';
import 'package:route_pulse_mobile/features/client/presentation/notifiers/get_clients_list_notifier.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/widgets/app_bottomsheet.dart';
import 'package:route_pulse_mobile/shared/widgets/button_with_loader.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';
import 'package:route_pulse_mobile/shared/widgets/labeled_field.dart';
import 'package:route_pulse_mobile/shared/widgets/pick_location_dialog.dart';

class CreateClientBottomsheet {
  Future show(BuildContext context) {
    return AppBottomSheet.show(
      context: context,
      builder: (sheetContext, setModalState) {
        return [
          Consumer(
            builder: (context, ref, child) {
              final state = ref.watch(createClientProvider);
              final vm = ref.read(createClientProvider.notifier);

              List<double>? selectedLocation;

              ref.listen(createClientProvider, (previous, next) {
                if (previous is HttpLoading && next is HttpSuccess) {
                  AppToast.success(context, 'Client créé avec succès');

                  ref.read(getClientsListProvider.notifier).refetch();

                  if (sheetContext.mounted) Navigator.pop(sheetContext, true);
                }
                if (next is HttpError) AppToast.error(context, next.message);
              });

              return StatefulBuilder(
                builder: (context, setLocalState) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
                    ),
                    child: Form(
                      key: vm.formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Ajouter un client',
                            style: TextStyle(fontSize: AppTypography.h5),
                          ),
                          const SizedBox(height: 24),

                          LabeledField(
                            label: 'Nom du client',
                            children: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'ex: Rakoto Jean',
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: CustomIcon(
                                    path: 'assets/icons/profile.svg',
                                  ),
                                ),
                              ),
                              onChanged: vm.setName,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Nom requis';
                                }
                                if (value.trim().length < 2) {
                                  return 'Au moins 2 caractères';
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          LabeledField(
                            label: 'Numéro mobile',
                            children: TextFormField(
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                hintText: 'ex: 034 12 345 67',
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: CustomIcon(
                                    path: 'assets/icons/call.svg',
                                  ),
                                ),
                              ),
                              onChanged: vm.setPhoneNumber,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Numéro requis';
                                }
                                final phone = value.trim().replaceAll(' ', '');
                                if (phone.length < 10) {
                                  return 'Numéro invalide (10 chiffres)';
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          LabeledField(
                            label: 'Adresse physique',
                            children: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      hintText: 'Votre adresse physique',
                                    ),
                                    onChanged: vm.setAddress,
                                    validator: (value) =>
                                        value == null || value.trim().isEmpty
                                        ? 'Adresse requise'
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 56,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: () => showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) => PickLocationDialog(
                                        onCancel: () {},
                                        onSelect: (location) {
                                          vm.setLocation(location);
                                          setLocalState(
                                            () => selectedLocation = location,
                                          );
                                        },
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      backgroundColor: selectedLocation != null
                                          ? AppColors.primary
                                          : AppColors.surface,
                                    ),
                                    child: Icon(
                                      Icons.my_location,
                                      color: selectedLocation != null
                                          ? Colors.white
                                          : AppColors.foreground,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          ButtonWithLoader(
                            text: 'Créer',
                            loadingText: 'Création en cours...',
                            isLoading: state is HttpLoading,
                            onPressed: state is HttpLoading
                                ? null
                                : () => vm.submit(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ];
      },
    );
  }
}

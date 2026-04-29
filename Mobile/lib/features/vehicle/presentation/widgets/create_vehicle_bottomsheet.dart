import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/core/utils/app_toast.dart';
import 'package:route_pulse_mobile/features/vehicle/presentation/notifiers/create_vehicle_notifier.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/widgets/app_bottomsheet.dart';
import 'package:route_pulse_mobile/shared/widgets/button_with_loader.dart';
import 'package:route_pulse_mobile/shared/widgets/labeled_field.dart';

class CreateVehicleBottomsheet {
  Future show(BuildContext context) {
    return AppBottomSheet.show(
      context: context,
      builder: (sheetContext, setModalState) {
        return [
          Consumer(
            builder: (context, ref, child) {
              final state = ref.watch(createVehicleProvider);
              final vm = ref.read(createVehicleProvider.notifier);

              ref.listen(createVehicleProvider, (previous, next) {
                if (previous is HttpLoading && next is HttpSuccess) {
                  AppToast.success(context, next.message ?? 'Véhicule créé');

                  if (sheetContext.mounted) Navigator.pop(sheetContext, true);
                }

                if (next is HttpError) AppToast.error(context, next.message);
              });

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
                        'Ajouter un véhicule',
                        style: TextStyle(fontSize: AppTypography.h5),
                      ),
                      const SizedBox(height: 24),

                      LabeledField(
                        label: 'Nom du véhicule',
                        children: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'ex: Kymco',
                          ),
                          onChanged: vm.setName,
                          validator: (value) => value?.trim().isEmpty ?? true
                              ? 'Nom requis'
                              : null,
                        ),
                      ),

                      const SizedBox(height: 20),

                      LabeledField(
                        label: 'Type de véhicule',
                        children: DropdownButtonFormField<VehicleType>(
                          decoration: const InputDecoration(
                            hintText: 'Sélectionnez',
                          ),
                          items: VehicleType.values
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) => vm.setType(value?.name ?? ''),
                          validator: (value) =>
                              value == null ? 'Type requis' : null,
                        ),
                      ),

                      const SizedBox(height: 20),

                      LabeledField(
                        label: 'Plaque (optionnel)',
                        children: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'AB-123-CD',
                          ),
                          onChanged: vm.setPlateNumber,
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
          ),
        ];
      },
    );
  }
}

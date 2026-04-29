import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/core/utils/app_toast.dart';
import 'package:route_pulse_mobile/features/vehicle/domain/entities/vehicle.dart';
import 'package:route_pulse_mobile/features/vehicle/presentation/notifiers/get_vehicles_list_notifier.dart';
import 'package:route_pulse_mobile/features/vehicle/presentation/notifiers/update_vehicle_notifier.dart';
import 'package:route_pulse_mobile/features/vehicle/presentation/states/update_vehicle_state.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/widgets/button_with_loader.dart';
import 'package:route_pulse_mobile/shared/widgets/labeled_field.dart';

class UpdateVehicleDialog extends ConsumerStatefulWidget {
  final Vehicle vehicle;

  const UpdateVehicleDialog({required this.vehicle});

  @override
  ConsumerState<UpdateVehicleDialog> createState() =>
      UpdateVehicleDialogState();
}

class UpdateVehicleDialogState extends ConsumerState<UpdateVehicleDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(updateVehicleProvider.notifier)
          .init(
            UpdateVehicleState(
              name: widget.vehicle.name,
              type: widget.vehicle.type.value,
              plateNumber: widget.vehicle.plateNumber,
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(updateVehicleProvider);
    final vm = ref.read(updateVehicleProvider.notifier);

    ref.listen(updateVehicleProvider, (previous, next) {
      if (previous is HttpLoading && next is HttpSuccess) {
        AppToast.success(context, 'Véhicule mis à jour');
	
	ref.read(getVehiclesListProvider.notifier).refetch();

        if (context.mounted) Navigator.pop(context, true);
      }
      if (next is HttpError) AppToast.error(context, next.message);
    });

    return AlertDialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      title: const Text(
        'Modifier les informations',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      content: Form(
        key: vm.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Modifiez les informations de votre véhicule.',
              style: TextStyle(color: AppColors.mutedForeground),
            ),
            const SizedBox(height: 20),
            LabeledField(
              label: 'Nom du véhicule',
              children: TextFormField(
                initialValue: widget.vehicle.name,
                decoration: const InputDecoration(hintText: 'ex: Kymco'),
                onChanged: vm.setName,
                validator: (value) =>
                    value?.trim().isEmpty ?? true ? 'Nom requis' : null,
              ),
            ),
            const SizedBox(height: 16),
            LabeledField(
              label: 'Type de véhicule',
              children: DropdownButtonFormField<VehicleType>(
                value: VehicleType.values.firstWhere(
                  (e) => e.name == widget.vehicle.type,
                  orElse: () => VehicleType.values.first,
                ),
                decoration: const InputDecoration(hintText: 'Sélectionnez'),
                items: VehicleType.values
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type.name)),
                    )
                    .toList(),
                onChanged: (value) => vm.setType(value?.name ?? ''),
                validator: (value) => value == null ? 'Type requis' : null,
              ),
            ),
            const SizedBox(height: 16),
            LabeledField(
              label: 'Plaque (optionnel)',
              children: TextFormField(
                initialValue: widget.vehicle.plateNumber,
                decoration: const InputDecoration(hintText: 'AB-123-CD'),
                onChanged: vm.setPlateNumber,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: state is HttpLoading
                    ? null
                    : () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                  textStyle: TextStyle(fontSize: AppTypography.small),
                ),
                child: const Text('Annuler'),
              ),
            ),
            Expanded(
              child: ButtonWithLoader(
                text: 'Enregistrer',
                loadingText: 'Mise à jour...',
                isLoading: state is HttpLoading,
                onPressed: state is HttpLoading
                    ? null
                    : () => vm.submit(widget.vehicle.id),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

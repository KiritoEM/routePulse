import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_pulse_mobile/core/utils/app_toast.dart';
import 'package:route_pulse_mobile/features/vehicle/domain/entities/vehicle.dart';
import 'package:route_pulse_mobile/features/vehicle/presentation/notifiers/delete_vehicle_notifier.dart';
import 'package:route_pulse_mobile/features/vehicle/presentation/notifiers/get_vehicles_list_notifier.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/widgets/confirm_delete_dialog.dart';

class DeleteVehicleDialog extends ConsumerWidget {
  final Vehicle vehicle;

  const DeleteVehicleDialog({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(deleteVehicleProvider);
    final vm = ref.read(deleteVehicleProvider.notifier);

    ref.listen(deleteVehicleProvider, (previous, next) {
      if (previous is HttpLoading && next is HttpSuccess) {
        AppToast.success(context, next.message ?? 'Véhicule supprimé');

        ref.read(getVehiclesListProvider.notifier).refetch();

        if (context.mounted) Navigator.pop(context, true);
        return;
      }

      if (next is HttpError) AppToast.error(context, next.message);
    });

    return ConfirmDeleteDialog(
      title: 'Supprimer le véhicule',
      message:
          'Voulez-vous vraiment supprimer ${vehicle.name} ? Cette action est irréversible.',
      isLoading: state is HttpLoading,
      onConfirm: () => vm.submit(vehicle.id),
    );
  }
}

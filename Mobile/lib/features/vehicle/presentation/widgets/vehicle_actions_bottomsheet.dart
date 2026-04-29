import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/features/vehicle/domain/entities/vehicle.dart';
import 'package:route_pulse_mobile/features/vehicle/presentation/widgets/update_vehicle_dialog.dart';
import 'package:route_pulse_mobile/shared/widgets/app_bottomsheet.dart';
import 'package:route_pulse_mobile/shared/widgets/bottomsheet_action.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';

class VehicleActionsBottomsheet {
  Future show(BuildContext context, Vehicle vehicle) {
    return AppBottomSheet.show(
      context: context,
      builder: (sheetContext, setModalState) {
        return [
          Column(
            children: [
              BottomsheetAction(
                label: 'Modifier',
                icon: SizedBox(
                  width: 32,
                  child: CustomIcon(path: 'assets/icons/start.svg', width: 32),
                ),
                onTap: () {
                  if (sheetContext.mounted && Navigator.canPop(sheetContext)) {
                    Navigator.pop(sheetContext);
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showUpdateDialog(context, vehicle);
                  });
                },
              ),
            ],
          ),
        ];
      },
    );
  }

  void _showUpdateDialog(BuildContext context, Vehicle vehicle) {
    showDialog(
      context: context,
      builder: (dialogContext) => UpdateVehicleDialog(vehicle: vehicle),
    );
  }
}

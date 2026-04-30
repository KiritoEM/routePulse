import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/features/client/domain/entities/client.dart';
import 'package:route_pulse_mobile/features/client/presentation/widgets/update_client_dialog.dart';
import 'package:route_pulse_mobile/shared/widgets/app_bottomsheet.dart';
import 'package:route_pulse_mobile/shared/widgets/bottomsheet_action.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';

class ClientActionsBottomsheet {
  Future show(BuildContext context, Client client) {
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
                    _showUpdateDialog(context, client);
                  });
                },
              ),
            ],
          ),
        ];
      },
    );
  }

  void _showUpdateDialog(BuildContext context, Client client) {
    showDialog(
      context: context,
      builder: (dialogContext) => UpdateClientDialog(client: client),
    );
  }
}

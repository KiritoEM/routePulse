import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/features/client/domain/entities/client.dart';
import 'package:route_pulse_mobile/features/client/presentation/widgets/delete_client_dialog.dart';
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
                  child: CustomIcon(path: 'assets/icons/edit.svg', width: 24),
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

              BottomsheetAction(
                isDestructive: true,
                label: 'Supprimer',
                icon: SizedBox(
                  width: 32,
                  child: CustomIcon(
                    path: 'assets/icons/trash.svg',
                    width: 24,
                    color: AppColors.error,
                  ),
                ),
                onTap: () {
                  if (sheetContext.mounted && Navigator.canPop(sheetContext)) {
                    Navigator.pop(sheetContext);
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showDeleteDialog(context, client);
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

  void _showDeleteDialog(BuildContext context, Client client) {
    showDialog(
      context: context,
      builder: (dialogContext) => DeleteClientDialog(client: client),
    );
  }
}

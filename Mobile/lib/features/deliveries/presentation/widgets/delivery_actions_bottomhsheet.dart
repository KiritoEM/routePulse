import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/utils/app_toast.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/bottomsheet_action.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/cancel_delivery_bottomsheet.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/report_delivery_bottomsheet.dart';
import 'package:route_pulse_mobile/shared/widgets/app_bottomsheet.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';

class DeliveryActionsBottomsheet {
  Future show(
    BuildContext context, {
    required String deliveryId,
    VoidCallback? onStart,
    bool showStartAction = true,
    bool showValidateAction = true,
    bool showReportAction = true,
  }) {
    return AppBottomSheet.show(
      context: context,
      builder: (sheetContext, setModalState) {
        return [
          Column(
            children: [
              if (showStartAction && onStart != null)
                BottomsheetAction(
                  label: 'Démarrer',
                  icon: SizedBox(
                    width: 32,
                    child: CustomIcon(
                      path: 'assets/icons/start.svg',
                      width: 32,
                    ),
                  ),
                  onTap: () {
                    if (sheetContext.mounted &&
                        Navigator.canPop(sheetContext)) {
                      Navigator.pop(sheetContext, true);
                    }
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      AppToast.info(context, 'Démarrage en cours...');
                    });
                    onStart();
                  },
                ),
              if (showValidateAction)
                BottomsheetAction(
                  label: 'Valider',
                  icon: SizedBox(
                    width: 32,
                    child: CustomIcon(
                      path: 'assets/icons/check-double.svg',
                      width: 32,
                    ),
                  ),
                  onTap: () {
                    AppToast.info(context, 'Valider bientôt disponible');
                  },
                ),
              if (showReportAction)
                BottomsheetAction(
                  label: 'Reporter',
                  icon: SizedBox(
                    width: 32,
                    child: CustomIcon(
                      path: 'assets/icons/warning.svg',
                      width: 24,
                    ),
                  ),
                  onTap: () {
                    ReportDeliveryBottomsheet().show(context, deliveryId);
                  },
                ),
              BottomsheetAction(
                isDestructive: true,
                label: 'Annuler',
                icon: SizedBox(
                  width: 32,
                  child: Icon(
                    Icons.close_rounded,
                    color: AppColors.error,
                    size: 26,
                  ),
                ),
                onTap: () {
                  CancelDeliveryBottomsheet().show(context, deliveryId);
                },
              ),
            ],
          ),
        ];
      },
    );
  }
}

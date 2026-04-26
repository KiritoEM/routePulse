import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/core/utils/app_toast.dart';
import 'package:route_pulse_mobile/core/utils/string_utils.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/notifiers/create_delivery_notifier.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/summary_card.dart';
import 'package:route_pulse_mobile/shared/widgets/labeled_field.dart';
import 'package:route_pulse_mobile/shared/widgets/stepper_header.dart';

class DeliveryConfirmationScreen extends ConsumerWidget {
  const DeliveryConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController _noteController = TextEditingController();
    final createDeliveryState = ref.watch(createDeliveryProvider);
    final createDeliveryVm = ref.read(createDeliveryProvider.notifier);

    ref.listen(createDeliveryProvider, (prev, next) {
      if (prev == null) return;

      if (prev.isLoading == true && next.hasError == false) {
        AppToast.info(context, 'Traitement en cours de votre livraison...');
        ref.invalidate(createDeliveryProvider);

        return;
      }

      AppToast.error(context, next.errorMessage!);
    });

    Future<void> handleSubmit() async {
      if (_noteController.text.isNotEmpty) {
        createDeliveryVm.setNotes(_noteController.text);
      }

      await createDeliveryVm.submit();
    }

    return SingleChildScrollView(
      clipBehavior: .none,
      padding: EdgeInsets.symmetric(horizontal: 16),

      child: Column(
        children: [
          const SizedBox(height: 24),
          StepperHeader(
            title: 'Notes et confirmation',
            description: Text(
              'Vérifiez les informations saisies avant de valider la création de la livraison',
              style: TextStyle(
                color: AppColors.mutedForeground,
                fontSize: AppTypography.body,
              ),
            ),
          ),

          const SizedBox(height: 32),

          Column(
            children: [
              LabeledField(
                label: 'Notes (optionnel)',
                children: TextField(
                  controller: _noteController,
                  decoration: InputDecoration(hintText: 'Ecrivez ici...'),
                  minLines: 4,
                  maxLines: 5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Delivery summary
          SummaryCard(
            clientName: createDeliveryState.clientName ?? 'Client non défini',
            address: createDeliveryState.address ?? 'Adresse non définie',
            timeSlot: StringUtils.formatTimeSlot(
              createDeliveryState.timeSlotStart,
              createDeliveryState.timeSlotEnd,
            ),
            totalPrice: createDeliveryState.articles.fold(
              0,
              (t, e) => t + e.price.toInt(),
            ),
          ),

          const SizedBox(height: 32),

          ElevatedButton(
            child: Text('Créer la livraison'),
            onPressed: () => handleSubmit(),
          ),
        ],
      ),
    );
  }
}

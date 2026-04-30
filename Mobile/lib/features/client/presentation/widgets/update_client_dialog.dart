import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/core/utils/app_toast.dart';
import 'package:route_pulse_mobile/features/client/domain/entities/client.dart';
import 'package:route_pulse_mobile/features/client/presentation/notifiers/get_clients_list_notifier.dart';
import 'package:route_pulse_mobile/features/client/presentation/notifiers/update_client_notifier.dart';
import 'package:route_pulse_mobile/features/client/presentation/states/update_client_state.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/widgets/button_with_loader.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';
import 'package:route_pulse_mobile/shared/widgets/labeled_field.dart';
import 'package:route_pulse_mobile/shared/widgets/pick_location_dialog.dart';

class UpdateClientDialog extends ConsumerStatefulWidget {
  final Client client;

  const UpdateClientDialog({required this.client});

  @override
  ConsumerState<UpdateClientDialog> createState() => _UpdateClientDialogState();
}

class _UpdateClientDialogState extends ConsumerState<UpdateClientDialog> {
  List<double>? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.client.location;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(updateClientProvider.notifier)
          .init(
            UpdateClientState(
              name: widget.client.name,
              phoneNumber: widget.client.phoneNumber,
              address: widget.client.address,
              city: widget.client.city,
              location: widget.client.location ?? [],
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(updateClientProvider);
    final vm = ref.read(updateClientProvider.notifier);

    ref.listen(updateClientProvider, (previous, next) {
      if (previous is HttpLoading && next is HttpSuccess) {
        AppToast.success(context, 'Client mis à jour');

        ref.read(getClientsListProvider.notifier).refetch();

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
        'Modifier le client',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: vm.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
	    crossAxisAlignment: .start,
            children: [
              const Text(
                'Modifiez les informations du client.',
                style: TextStyle(color: AppColors.mutedForeground),
              ),
              const SizedBox(height: 20),

              LabeledField(
                label: 'Nom du client',
                children: TextFormField(
                  initialValue: widget.client.name,
                  decoration: InputDecoration(
                    hintText: 'ex: Rakoto Jean',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(16),
                      child: CustomIcon(path: 'assets/icons/profile.svg'),
                    ),
                  ),
                  onChanged: vm.setName,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nom requis';
                    }
                    if (value.trim().length < 2) return 'Au moins 2 caractères';
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 16),

              LabeledField(
                label: 'Numéro mobile',
                children: TextFormField(
                  initialValue: widget.client.phoneNumber,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'ex: 034 12 345 67',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(16),
                      child: CustomIcon(path: 'assets/icons/call.svg'),
                    ),
                  ),
                  onChanged: vm.setPhoneNumber,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Numéro requis';
                    }
                    final phone = value.trim().replaceAll(' ', '');
                    if (phone.length < 10)
                      return 'Numéro invalide (10 chiffres)';
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 16),

              LabeledField(
                label: 'Adresse physique',
                children: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: widget.client.address,
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
                    StatefulBuilder(
                      builder: (context, setLocalState) => SizedBox(
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
                                  () => _selectedLocation = location,
                                );
                              },
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: _selectedLocation != null
                                ? AppColors.primary
                                : AppColors.surface,
                          ),
                          child: Icon(
                            Icons.my_location,
                            color: _selectedLocation != null
                                ? Colors.white
                                : AppColors.foreground,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
                    : () => vm.submit(widget.client.id),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

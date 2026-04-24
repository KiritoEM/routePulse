import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/utils/app_toast.dart';
import 'package:route_pulse_mobile/features/client/domain/entities/client.dart';
import 'package:route_pulse_mobile/features/client/presentation/states/create_client_state.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/notifiers/create_delivery_notifier.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/notifiers/delivery_create_client_notifier.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/notifiers/search_client_notifier.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/client_autocomplete.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/pick_location_dialog.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/widgets/button_with_loader.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';
import 'package:route_pulse_mobile/shared/widgets/labeled_field.dart';

class AddUserInfosForm extends ConsumerStatefulWidget {
  const AddUserInfosForm({super.key});

  @override
  ConsumerState<AddUserInfosForm> createState() => _AddUserInfosFormState();
}

class _AddUserInfosFormState extends ConsumerState<AddUserInfosForm> {
  final _formKey = GlobalKey<FormState>();
  final _clientNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String? _selectedClientId;
  List<double>? _selectedLocation;
  bool _isCreatingClient = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _onClientSelected(Client client) {
    setState(() => _selectedClientId = client.id);
    _clientNameController.text = client.name;
    _phoneController.text = client.phoneNumber;
  }

  void _onSelectLocation(List<double> location) {
    setState(() => _selectedLocation = location);
  }

  Future<void> _submit(
    CreateDeliveryNotifier createDeliveryVm,
    DeliveryCreateClientNotifier createClientVm,
  ) async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedLocation == null) {
      AppToast.error(context, 'Veuillez choisir une localisation sur la carte');
      return;
    }

    if (_selectedClientId != null) {
      createDeliveryVm.setClientInfo(
        clientId: _selectedClientId!,
        address: _addressController.text.trim(),
        lat: _selectedLocation![0],
        lng: _selectedLocation![1],
      );
      return;
    }

    final clientData = CreateClientState(
      name: _clientNameController.text.trim(),
      phone: _phoneController.text.trim().isNotEmpty
          ? _phoneController.text.trim()
          : null,
      address: _addressController.text.trim(),
      location: _selectedLocation ?? [],
    );

    await createClientVm.createClient(clientData);
  }

  @override
  Widget build(BuildContext context) {
    final createDeliveryVm = ref.read(createDeliveryProvider.notifier);
    final createClientVm = ref.read(deliveryCreateClientProvider.notifier);

    ref.listen(searchClientProvider, (prev, next) {
      if (next is HttpError) {
        AppToast.error(context, next.message);
      }
    });

    ref.listen(deliveryCreateClientProvider, (prev, next) {
      if (next is HttpLoading) {
        setState(() => _isCreatingClient = true);
      } else if (next is HttpError) {
        setState(() => _isCreatingClient = false);
        AppToast.error(context, next.message);
      } else if (next is HttpSuccess) {
        setState(() => _isCreatingClient = false);
        AppToast.success(context, 'Client créé avec succès');

        final responseData = next.data;
        String? newClientId;

        if (responseData is Map<String, dynamic>) {
          newClientId = responseData['id']?.toString();
        } else if (responseData is List && responseData.isNotEmpty) {
          newClientId = responseData[0]['id']?.toString();
        }

        createDeliveryVm.setClientInfo(
          clientId: newClientId ?? _clientNameController.text.trim(),
          address: _addressController.text.trim(),
          lat: _selectedLocation![0],
          lng: _selectedLocation![1],
        );
      }
    });

    return Form(
      key: _formKey,
      child: Column(
        children: [
          LabeledField(
            label: 'Nom du client',
            children: Autocomplete<Client>(
              fieldViewBuilder:
                  (
                    context,
                    textEditingController,
                    focusNode,
                    onFieldSubmitted,
                  ) {
                    textEditingController.text = _clientNameController.text;
                    textEditingController.addListener(() {
                      _clientNameController.text = textEditingController.text;
                    });

                    return TextFormField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'ex: Rakoto Jean',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(16),
                          child: CustomIcon(path: 'assets/icons/profile.svg'),
                        ),
                      ),
                      onFieldSubmitted: (_) => onFieldSubmitted(),
                      onChanged: (value) {
                        if (_selectedClientId != null) {
                          setState(() => _selectedClientId = null);
                        }
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Veuillez entrer le nom du client';
                        }
                        if (value.trim().length < 2) {
                          return 'Le nom doit contenir au moins 2 caractères';
                        }
                        return null;
                      },
                    );
                  },
              displayStringForOption: (option) => option.name,
              optionsBuilder: (textEditingValue) async {
                final query = textEditingValue.text.trim();
                if (query.length < 1) return Iterable<Client>.empty();

                final notifier = ref.read(searchClientProvider.notifier);
                await notifier.search(query);

                final state = ref.read(searchClientProvider);
                if (state is HttpSuccess) {
                  final data = state.data as List<dynamic>;

                  return data.whereType<Client>().toList();
                }

                return Iterable<Client>.empty();
              },
              optionsViewBuilder: (context, onSelected, options) =>
                  ClientAutocompleteView(
                    options: options,
                    onSelect: (option) {
                      onSelected(option);
                      _onClientSelected(option);
                    },
                  ),
              onSelected: _onClientSelected,
            ),
          ),

          const SizedBox(height: 16),

          LabeledField(
            label: 'Numéro mobile',
            children: TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'ex: 034 12 345 67',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(16),
                  child: CustomIcon(path: 'assets/icons/call.svg'),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez entrer un numéro mobile';
                }
                final phone = value.trim().replaceAll(' ', '');
                if (phone.length < 10) {
                  return 'Veuillez entrer un numéro valide (10 chiffres)';
                }
                if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
                  return 'Veuillez entrer uniquement des chiffres';
                }
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
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: 'Votre adresse physique',
                      suffixIcon: _selectedLocation != null
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            )
                          : null,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(16),
                        child: CustomIcon(path: 'assets/icons/location.svg'),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez entrer une adresse physique';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 56,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => _showPickLocationDialog(context),
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
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ButtonWithLoader(
            text: 'Continuer',
            loadingText: 'Traitement en cours...',
            isLoading: _isCreatingClient,
            onPressed: () => _submit(createDeliveryVm, createClientVm),
          ),
        ],
      ),
    );
  }

  void _showPickLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          PickLocationDialog(onCancel: () {}, onSelect: _onSelectLocation),
    );
  }
}

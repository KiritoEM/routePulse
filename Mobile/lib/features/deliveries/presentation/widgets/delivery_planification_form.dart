import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:route_pulse_mobile/core/constants/router_constant.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/core/utils/date_utils.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/notifiers/create_delivery_notifier.dart';
import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/date_picker.dart';
import 'package:route_pulse_mobile/features/vehicle/domain/entities/vehicle.dart';
import 'package:route_pulse_mobile/features/vehicle/presentation/notifiers/get_vehicles_list_notifier.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';
import 'package:route_pulse_mobile/shared/widgets/error_text.dart';
import 'package:route_pulse_mobile/shared/widgets/labeled_field.dart';
import 'package:route_pulse_mobile/shared/widgets/time_slot_picker.dart';

class DeliveryPlanificationForm extends ConsumerStatefulWidget {
  const DeliveryPlanificationForm({super.key});

  @override
  ConsumerState<DeliveryPlanificationForm> createState() =>
      _DeliveryPlanificationFormState();
}

class _DeliveryPlanificationFormState
    extends ConsumerState<DeliveryPlanificationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _vehicleNameController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _timeSlotStart = TimeOfDay.fromDateTime(DateTime.now());
  TimeOfDay? _timeSlotEnd;
  Vehicle? _selectedVehicle;

  @override
  Widget build(BuildContext context) {
    final vehiclesState = ref.watch(getVehiclesListProvider);
    final createDeliveryVm = ref.read(createDeliveryProvider.notifier);

    void handleSubmit() {
      if (!_formKey.currentState!.validate()) return;

      createDeliveryVm.setSchedule(
        deliveryDate: _selectedDate.toIso8601String(),
        timeSlotStart: CustomDateUtils.formatTime(_timeSlotStart!),
        timeSlotEnd: CustomDateUtils.formatTime(_timeSlotEnd!),
        vehicleId: _selectedVehicle!.id,
      );

      // navigate to next step
      context.push(RouterConstant.CREATE_DELIVERY_STEP3);
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabeledField(
            label: 'Date de livraison',
            children: FormField<DateTime>(
              builder: (field) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DatePicker(
                    selectedDate: _selectedDate,
                    hasError: field.hasError,
                    onPickDate: (DateTime? date) {
                      if (date != null && context.mounted) {
                        setState(() => _selectedDate = date);
                      }
                    },
                  ),
                  if (field.hasError) ErrorText(field.errorText!),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          LabeledField(
            label: 'Créneau horaire',
            children: FormField<bool>(
              validator: (_) {
                if (_timeSlotStart == null || _timeSlotEnd == null) {
                  return 'Veuillez définir un créneau horaire';
                }
                final startMins =
                    _timeSlotStart!.hour * 60 + _timeSlotStart!.minute;
                final endMins = _timeSlotEnd!.hour * 60 + _timeSlotEnd!.minute;
                if (endMins <= startMins) {
                  return "L'heure de fin doit être après l'heure de début";
                }
                return null;
              },
              builder: (field) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TimeSlotPicker(
                    timeSlotStart: _timeSlotStart,
                    timeSlotEnd: _timeSlotEnd,
                    hasError: field.hasError,
                    pickStartTime: (TimeOfDay? time) {
                      if (time != null && context.mounted) {
                        setState(() {
                          _timeSlotStart = time;
                        });
                      }
                    },
                    pickEndTime: (TimeOfDay? time) {
                      if (time != null && context.mounted) {
                        setState(() {
                          _timeSlotEnd = time;
                        });
                      }
                    },
                  ),

                  if (field.hasError) ErrorText(field.errorText!),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          LabeledField(
            label: 'Véhicule',
            children: FormField<Vehicle>(
              validator: (_) => _selectedVehicle == null
                  ? 'Veuillez sélectionner un véhicule'
                  : null,
              builder: (field) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildVehiclesDropdown(context, vehiclesState),

                  if (field.hasError) ErrorText(field.errorText!),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: handleSubmit,
              child: const Text('Continuer'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehiclesDropdown(BuildContext context, HttpState vehiclesState) {
    return switch (vehiclesState) {
      HttpInitial() || HttpLoading() => SkeletonLine(
        style: SkeletonLineStyle(
          height: 55,
          width: double.infinity,
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
      ),

      HttpError() => Text(
        'Une erreur s\'est produite lors de l\'affichage des véhicules',
        style: TextStyle(color: AppColors.error),
      ),

      HttpSuccess(:final data) =>
        data.isEmpty
            ? IntrinsicWidth(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  label: Text('Ajouter un véhicule'),
                  icon: Icon(Icons.add),
                ),
              )
            : DropdownMenu<Vehicle>(
                controller: _vehicleNameController,
                expandedInsets: EdgeInsets.zero,
                hintText: 'Sélectionner un véhicule',
                menuStyle: MenuStyle(
                  surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  backgroundColor: WidgetStatePropertyAll(Colors.white),
                ),
                inputDecorationTheme: const InputDecorationTheme(
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  hintStyle: TextStyle(color: AppColors.foreground),
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                ),
                dropdownMenuEntries: (List<Vehicle>.from(data))
                    .map(
                      (vehicle) => DropdownMenuEntry<Vehicle>(
                        style: ButtonStyle(
                          padding: WidgetStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          backgroundColor: WidgetStateColor.resolveWith((
                            states,
                          ) {
                            return states.contains(WidgetState.selected)
                                ? AppColors.surface
                                : Colors.white;
                          }),
                        ),
                        value: vehicle,
                        label: '',
                        labelWidget: Row(
                          spacing: 12,
                          children: [
                            // badge
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.Primary100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.all(8.5),
                              child: CustomIcon(
                                path: vehicle.type.icon,
                                color: AppColors.primary,
                                width: 32,
                              ),
                            ),

                            // infos
                            Column(
                              children: [
                                Text(
                                  vehicle.name,
                                  style: TextStyle(
                                    fontSize: AppTypography.body + 1,
                                  ),
                                ),

                                if (vehicle.plateNumber != null) ...[
                                  const SizedBox(height: 4),

                                  Text(
                                    vehicle.plateNumber!,
                                    style: TextStyle(
                                      color: AppColors.mutedForeground,
                                      fontSize: AppTypography.small,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                        trailingIcon: vehicle.id == _selectedVehicle?.id
                            ? Padding(
                                padding: EdgeInsets.all(12),
                                child: CustomIcon(
                                  path: 'assets/icons/check.svg',
                                  color: AppColors.info,
                                ),
                              )
                            : null,
                      ),
                    )
                    .toList(),
                onSelected: (Vehicle? vehicle) {
                  if (vehicle != null && context.mounted) {
                    setState(() => _selectedVehicle = vehicle);
                    _vehicleNameController.text = vehicle.name;
                  }
                },
              ),
      _ => const SizedBox.shrink(),
    };
  }
}

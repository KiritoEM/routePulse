// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:route_pulse_mobile/core/themes/app_colors.dart';
// import 'package:route_pulse_mobile/features/deliveries/presentation/notifiers/create_delivery_notifier.dart';
// import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/tappable_field.dart';
// import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/vehicle_dropdown_header.dart';
// import 'package:route_pulse_mobile/features/deliveries/presentation/widgets/vehicle_dropdown_list.dart';
// import 'package:route_pulse_mobile/features/vehicle/domain/entities/vehicle.dart';
// import 'package:route_pulse_mobile/features/vehicle/presentation/notifiers/get_vehicles_list_notifier.dart';
// import 'package:route_pulse_mobile/shared/states/http_state.dart';
// import 'package:route_pulse_mobile/shared/widgets/labeled_field.dart';
// import 'package:intl/intl.dart';
//
// class DeliveryPlanificationForm extends ConsumerStatefulWidget {
//   const DeliveryPlanificationForm({super.key});
//
//   @override
//   ConsumerState<DeliveryPlanificationForm> createState() =>
//       _DeliveryPlanificationFormState();
// }
//
// class _DeliveryPlanificationFormState
//     extends ConsumerState<DeliveryPlanificationForm> {
//   final _formKey = GlobalKey<FormState>();
//
//   DateTime? _selectedDate;
//   TimeOfDay? _timeSlotStart;
//   TimeOfDay? _timeSlotEnd;
//   Vehicle? _selectedVehicle; 
//
//   String _formatDate(DateTime date) => DateFormat('dd/MM/yy').format(date);
//
//   String _formatTime(TimeOfDay t) =>
//       '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
//
//   Future<void> _pickDate() async {
//     final now = DateTime.now();
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? now,
//       firstDate: now,
//       lastDate: now.add(const Duration(days: 365)),
//     );
//     if (picked != null && mounted) setState(() => _selectedDate = picked);
//   }
//
//   Future<void> _pickTime({required bool isStart}) async {
//     final initial = isStart
//         ? (_timeSlotStart ?? const TimeOfDay(hour: 8, minute: 0))
//         : (_timeSlotEnd ?? const TimeOfDay(hour: 12, minute: 30));
//
//     final picked = await showTimePicker(context: context, initialTime: initial);
//     if (picked != null && mounted) {
//       setState(() {
//         if (isStart) {
//           _timeSlotStart = picked;
//         } else {
//           _timeSlotEnd = picked;
//         }
//       });
//     }
//   }
//
//   void _submit() {
//     if (!_formKey.currentState!.validate()) return;
//
//     ref.read(createDeliveryProvider.notifier).setSchedule(
//       deliveryDate: _selectedDate!.toIso8601String(),
//       timeSlotStart: _formatTime(_timeSlotStart!),
//       timeSlotEnd: _formatTime(_timeSlotEnd!),
//       vehicleId: _selectedVehicle!.id, 
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final vehiclesState = ref.watch(getVehiclesListProvider);
//
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           LabeledField(
//             label: 'Date de livraison',
//             children: FormField<DateTime>(
//               validator: (_) => _selectedDate == null ? 'Veuillez choisir une date' : null,
//               builder: (field) => Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TappableField(
//                     text: _selectedDate != null ? _formatDate(_selectedDate!) : 'jj/mm/aa',
//                     hasValue: _selectedDate != null,
//                     suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
//                     hasError: field.hasError,
//                     onTap: _pickDate,
//                   ),
//                   if (field.hasError) _ErrorText(field.errorText!),
//                 ],
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 16),
//
//           LabeledField(
//             label: 'Créneau horaire',
//             children: FormField<bool>(
//               validator: (_) {
//                 if (_timeSlotStart == null || _timeSlotEnd == null) {
//                   return 'Veuillez définir un créneau horaire';
//                 }
//                 final startMins = _timeSlotStart!.hour * 60 + _timeSlotStart!.minute;
//                 final endMins = _timeSlotEnd!.hour * 60 + _timeSlotEnd!.minute;
//                 if (endMins <= startMins) {
//                   return "L'heure de fin doit être après l'heure de début";
//                 }
//                 return null;
//               },
//               builder: (field) => Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(children: [
//                     Expanded(child: TappableField(
//                       text: _timeSlotStart != null ? _formatTime(_timeSlotStart!) : '00:00',
//                       hasValue: _timeSlotStart != null,
//                       hasError: field.hasError,
//                       onTap: () => _pickTime(isStart: true),
//                     )),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8),
//                       child: Text('—', style: TextStyle(color: AppColors.foreground.withOpacity(0.5), fontSize: 18)),
//                     ),
//                     Expanded(child: TappableField(
//                       text: _timeSlotEnd != null ? _formatTime(_timeSlotEnd!) : '00:00',
//                       hasValue: _timeSlotEnd != null,
//                       hasError: field.hasError,
//                       onTap: () => _pickTime(isStart: false),
//                     )),
//                   ]),
//                   if (field.hasError) _ErrorText(field.errorText!),
//                 ],
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 16),
//
//           LabeledField(
//             label: 'Véhicule',
//             children: FormField<Vehicle>(
//               validator: (_) => _selectedVehicle == null ? 'Veuillez sélectionner un véhicule' : null,
//               builder: (field) => Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Header du dropdown
//                   VehicleDropdownHeader(
//                     selected: _selectedVehicle,
//                     hasError: field.hasError,
//                     isExpanded: _isVehicleExpanded,
//                     onTap: () => setState(() => _isVehicleExpanded = !_isVehicleExpanded),
//                   ),
//
//                   if (vehiclesState is HttpLoading)
//                     const Padding(
//                       padding: EdgeInsets.all(16),
//                       child: Center(child: CircularProgressIndicator()),
//                     )
//                   else if (vehiclesState is HttpError)
//                     Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Text(
//                         'Erreur de chargement',
//                         style: TextStyle(color: AppColors.error),
//                       ),
//                     )
//                   else if (_isVehicleExpanded)
//                     VehicleDropdownList(
//                       vehicles: ,                       selectedId: _selectedVehicle?.id,
//                       onSelect: (vehicle) => setState(() {
//                         _selectedVehicle = vehicle;
//                         _isVehicleExpanded = false;
//                         field.didChange(vehicle);
//                       }),
//                     ),
//
//                   if (field.hasError) _ErrorText(field.errorText!),
//                 ],
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 32),
//
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: _submit,
//               child: const Text('Continuer'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   bool _isVehicleExpanded = false;
// }
//
// class _ErrorText extends StatelessWidget {
//   const _ErrorText(this.message);
//   final String message;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 6, left: 4),
//       child: Text(
//         message,
//         style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.error),
//       ),
//     );
//   }
// }

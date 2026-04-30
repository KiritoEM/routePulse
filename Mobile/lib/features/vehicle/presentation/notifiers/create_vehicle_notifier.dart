import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/vehicle/data/vehicle_repository_impl.dart';
import 'package:route_pulse_mobile/features/vehicle/presentation/states/create_vehicle_state.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

part 'create_vehicle_notifier.g.dart';

@riverpod
class CreateVehicleNotifier extends _$CreateVehicleNotifier {
  final _vehicleRepository = VehicleRepositoryImpl();
  
  CreateVehicleState _vehicle = const CreateVehicleState(name: '', type: '');
  final _formKey = GlobalKey<FormState>();

  // Getters
  GlobalKey<FormState> get formKey => _formKey;

  @override
  HttpState build() => const HttpState.init();

  void setName(String name) {
    _vehicle = _vehicle.copyWith(name: name);
  }

  void setType(String type) {
    _vehicle = _vehicle.copyWith(type: type);
  }

  void setPlateNumber(String? plateNumber) {
    _vehicle = _vehicle.copyWith(plateNumber: plateNumber ?? '');
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    state = const HttpState.loading();

    final response = await _vehicleRepository.createVehicle(_vehicle);

    if (response.isSucess) {
      state = HttpState.success(data: response.data);
      return;
    }

    state = HttpState.error(
      errorType: response.errorType ?? NetworkErrorType.server,
      message: response.message ?? 'Impossible de créer le véhicule',
    );
  }
}

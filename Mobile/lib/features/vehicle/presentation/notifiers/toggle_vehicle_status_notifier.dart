import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/vehicle/data/vehicle_repository_impl.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

part 'toggle_vehicle_status_notifier.g.dart';

@riverpod
class ToggleVehicleStatusNotifier extends _$ToggleVehicleStatusNotifier {
  final _vehicleRepository = VehicleRepositoryImpl();

  @override
  HttpState build() => const HttpState.init();

  Future<void> submit(String vehicleId, bool isActive) async {
    state = const HttpState.loading();

    final response = await _vehicleRepository.toggleVehicleStatus(
      vehicleId,
      isActive,
    );

    if (response.isSucess) {
      state = HttpState.success(message: response.message, data: response.data);
      return;
    }

    state = HttpState.error(
      errorType: response.errorType ?? NetworkErrorType.server,
      message: response.message ?? 'Impossible de modifier le véhicule',
    );
  }
}

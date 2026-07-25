import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/vehicle/data/vehicle_repository_impl.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

part 'delete_vehicle_notifier.g.dart';

@riverpod
class DeleteVehicleNotifier extends _$DeleteVehicleNotifier {
  final _vehicleRepository = VehicleRepositoryImpl();

  @override
  HttpState build() => const HttpState.init();

  Future<void> submit(String vehicleId) async {
    state = const HttpState.loading();

    final response = await _vehicleRepository.deleteVehicle(vehicleId);

    if (response.isSucess) {
      state = HttpState.success(message: response.message);
      return;
    }

    state = HttpState.error(
      errorType: response.errorType ?? NetworkErrorType.server,
      message: response.message ?? 'Impossible de supprimer le véhicule',
    );
  }
}

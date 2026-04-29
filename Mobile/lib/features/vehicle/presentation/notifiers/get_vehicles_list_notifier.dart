import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/vehicle/data/vehicle_repository_impl.dart';
import 'package:route_pulse_mobile/features/vehicle/domain/entities/vehicle.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

part 'get_vehicles_list_notifier.g.dart';

@riverpod
class GetVehiclesListNotifier extends _$GetVehiclesListNotifier {
  final VehicleRepositoryImpl _vehicleRepository = VehicleRepositoryImpl();

  Future<void> _fetchVehiclesList(bool Function() isCancelled) async {
    state = const HttpState.loading();
    await Future.delayed(const Duration(milliseconds: 500));

    if (isCancelled()) return;

    final response = await _vehicleRepository.getAllVehicles();

    if (isCancelled()) return;

    if (response.isSucess) {
      state = HttpState.success(data: response.data as List<Vehicle>);
      return;
    }

    state = HttpState.error(
      errorType: response.errorType ?? NetworkErrorType.server,
      message: response.message ?? 'Impossible de récupérer les véhicules',
    );
  }

  @override
  HttpState build() {
    bool cancelled = false;
    ref.onDispose(() => cancelled = true);

    _fetchVehiclesList(() => cancelled);

    return const HttpState.loading();
  }
}

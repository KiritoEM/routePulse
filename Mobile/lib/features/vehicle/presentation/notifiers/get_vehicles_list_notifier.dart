import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/features/vehicle/data/vehicle_repository_impl.dart';
import 'package:route_pulse_mobile/features/vehicle/domain/entities/vehicle.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

part 'get_vehicles_list_notifier.g.dart';

@riverpod
class GetVehiclesListNotifier extends _$GetVehiclesListNotifier {
  final VehicleRepositoryImpl _vehicleRepository = VehicleRepositoryImpl();

  Future<void> _fetchVehiclesList() async {
    state = const HttpState.loading();

    final response = await _vehicleRepository.getAllVehicles();

    if (response.isSucess) {
      state = HttpState.success(data: response.data as List<Vehicle>);
      return;
    }

    state = HttpState.error(
      errorType: response.errorType ?? NetworkErrorType.server,
      message: response.message ?? 'Impossible de récupérer les véhicules',
    );
  }

  void startLoading() {
    state = HttpState.loading();
  }

  Future<void> refetch() async {
    state = HttpState.loading();

    await _fetchVehiclesList();
  }

  @override
  HttpState build() {
    _fetchVehiclesList();

    return const HttpState.loading();
  }
}

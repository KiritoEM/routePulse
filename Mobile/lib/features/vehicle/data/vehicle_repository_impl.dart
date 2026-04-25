// features/vehicle/data/repositories/vehicle_repository_impl.dart
import 'package:dio/dio.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/utils/app_logger.dart';
import 'package:route_pulse_mobile/core/utils/network_error_handler.dart';
import 'package:route_pulse_mobile/features/vehicle/data/datasources/vehicle_remote_datasource.dart';
import 'package:route_pulse_mobile/features/vehicle/data/models/vehicle_dto.dart';
import 'package:route_pulse_mobile/features/vehicle/domain/entities/vehicle.dart';
import 'package:route_pulse_mobile/features/vehicle/domain/repositories/vehicle_repository.dart';
import 'package:route_pulse_mobile/shared/services/network_checking_service.dart';
import 'package:route_pulse_mobile/shared/states/api_reponse.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleRemoteDatasource _vehicleRemoteDatasource =
      VehicleRemoteDatasource();

  @override
  Future<ApiResponse<List<Vehicle>>> getAllVehicles() async {
    final bool isOnline = await NetworkCheckingService.checkInternet();

    try {
      final responseData = await _vehicleRemoteDatasource.getAllVehicles();

      final vehicles = (responseData['data'] as List) 
          .map((vehicle) => VehicleDto.fromJson(vehicle).toEntity())
          .toList();

      return ApiResponse(
        message: 'Véhicules récupérés avec succès.',
        data: vehicles,
      );
    } on DioException catch (err) {
      AppLogger.logger.e(
        'DioException while fetching vehicles: ${err.response?.statusCode} - ${err.message} - ${err.error}',
      );

      return ApiResponse(
        hasError: true,
        message: NetworkErrorHandler.handleError(err)['message'],
        errorType:
            NetworkErrorHandler.handleError(err)['type'] as NetworkErrorType,
      );
    } catch (err) {
      AppLogger.logger.e('Error while fetching vehicles: $err');
      return ApiResponse(
        hasError: true,
        message: 'Impossible de récupérer les véhicules. Veuillez réessayer.',
        errorType: NetworkErrorType.server,
      );
    }
  }
}

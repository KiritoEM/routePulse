// features/vehicle/data/repositories/vehicle_repository_impl.dart
import 'package:dio/dio.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/utils/app_logger.dart';
import 'package:route_pulse_mobile/core/utils/network_error_handler.dart';
import 'package:route_pulse_mobile/features/auth/data/auth_repository_impl.dart';
import 'package:route_pulse_mobile/features/vehicle/data/datasources/vehicle_local_datasource.dart';
import 'package:route_pulse_mobile/features/vehicle/data/datasources/vehicle_remote_datasource.dart';
import 'package:route_pulse_mobile/features/vehicle/data/models/vehicle_dto.dart';
import 'package:route_pulse_mobile/features/vehicle/domain/entities/vehicle.dart';
import 'package:route_pulse_mobile/features/vehicle/domain/repositories/vehicle_repository.dart';
import 'package:route_pulse_mobile/shared/services/network_checking_service.dart';
import 'package:route_pulse_mobile/shared/states/api_reponse.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleRemoteDatasource _vehicleRemoteDatasource =
      VehicleRemoteDatasource();
  final VehicleLocalDatasource _vehicleLocalDatasource =
      VehicleLocalDatasource();
  final AuthRepositoryImpl _authRepository = AuthRepositoryImpl();

  @override
  Future<ApiResponse<List<Vehicle>>> getAllVehicles() async {
    final bool isOnline = await NetworkCheckingService.checkInternet();
    final currentUser = await _authRepository.getCurrentUser();
    final String userId = currentUser.data['id'];

    if (!isOnline) {
      return _getAllVehiclesLocally(userId);
    }

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

      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout ||
          err.type == DioExceptionType.connectionError) {
        return _getAllVehiclesLocally(userId);
      }

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

  Future<ApiResponse<List<Vehicle>>> _getAllVehiclesLocally(
    String userId,
  ) async {
    try {
      final vehicles = await _vehicleLocalDatasource.getAllVehicles(userId);

      return ApiResponse(
        message: 'Véhicules récupérés avec succès.',
        data: vehicles,
      );
    } catch (err) {
      AppLogger.logger.e('Error while fetching vehicles locally: $err');
      return ApiResponse(
        hasError: true,
        message: 'Impossible de récupérer les véhicules. Veuillez réessayer.',
        errorType: NetworkErrorType.server,
      );
    }
  }
}

import 'package:dio/dio.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/utils/app_logger.dart';
import 'package:route_pulse_mobile/core/utils/network_error_handler.dart';
import 'package:route_pulse_mobile/features/client/data/datasources/client_remote_datasource.dart';
import 'package:route_pulse_mobile/features/client/data/models/client_dto.dart';
import 'package:route_pulse_mobile/features/client/domain/repositories/client_repository.dart';
import 'package:route_pulse_mobile/features/client/presentation/states/create_client_state.dart';
import 'package:route_pulse_mobile/shared/services/network_checking_service.dart';
import 'package:route_pulse_mobile/shared/states/api_reponse.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientRemoteDatasource _clientRemoteDatasource = ClientRemoteDatasource();
 
  @override
  Future<ApiResponse> searchClientsByName(String name) async {
    final bool isOnline = await NetworkCheckingService.checkInternet();

    if (!isOnline) {
      return ApiResponse(
        hasError: true,
        message: 'Pas de connexion internet. Veuillez réessayer.',
        errorType: NetworkErrorType.network,
      );
    }

    try {
      final responseData = await _clientRemoteDatasource.searchClientsByName(name);

       final clients = responseData['data']
          .map((delivery) => ClientDto.fromJson(delivery).toEntity())
          .toList();

      return ApiResponse(
        message: 'Clients récupérés avec succès.',
        data: clients,
      );
    } on DioException catch (err) {
      AppLogger.logger.e(
        'DioException while searching clients: ${err.response?.statusCode} - ${err.message} - ${err.error}',
      );

      return ApiResponse(
        hasError: true,
        message: NetworkErrorHandler.handleError(err)['message'],
        errorType:
            NetworkErrorHandler.handleError(err)['type'] as NetworkErrorType,
      );
    } catch (err) {
      AppLogger.logger.e('Error while searching clients: $err');

      return ApiResponse(
        hasError: true,
        message: 'Impossible de rechercher les clients. Veuillez réessayer.',
        errorType: NetworkErrorType.server,
      );
    }
  }

  @override
  Future<ApiResponse> createClient(CreateClientState data) async {
    final bool isOnline = await NetworkCheckingService.checkInternet();

    if (!isOnline) {
      return ApiResponse(
        hasError: true,
        message: 'Pas de connexion internet. Veuillez réessayer.',
        errorType: NetworkErrorType.network,
      );
    }

    try {
      final response = await _clientRemoteDatasource.createClient(data);

      return ApiResponse(
        message: 'Client créé avec succès.',
        data: response,
      );
    } on DioException catch (err) {
      AppLogger.logger.e(
        'DioException while creating client: ${err.response?.statusCode} - ${err.message} - ${err.error}',
      );

      return ApiResponse(
        hasError: true,
        message: NetworkErrorHandler.handleError(err)['message'],
        errorType:
            NetworkErrorHandler.handleError(err)['type'] as NetworkErrorType,
      );
    } catch (err) {
      AppLogger.logger.e('Error while creating client: $err');

      return ApiResponse(
        hasError: true,
        message: 'Impossible de créer le client. Veuillez réessayer.',
        errorType: NetworkErrorType.server,
      );
    }
  }
}

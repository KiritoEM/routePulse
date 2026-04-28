import 'package:dio/dio.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/local_db/models/client_model.dart';
import 'package:route_pulse_mobile/core/utils/app_logger.dart';
import 'package:route_pulse_mobile/core/utils/network_error_handler.dart';
import 'package:route_pulse_mobile/features/auth/data/auth_repository_impl.dart';
import 'package:route_pulse_mobile/features/client/data/datasources/client_local_datasource.dart';
import 'package:route_pulse_mobile/features/client/data/datasources/client_remote_datasource.dart';
import 'package:route_pulse_mobile/features/client/data/models/client_dto.dart';
import 'package:route_pulse_mobile/features/client/domain/entities/client.dart';
import 'package:route_pulse_mobile/features/client/domain/repositories/client_repository.dart';
import 'package:route_pulse_mobile/features/client/presentation/states/create_client_state.dart';
import 'package:route_pulse_mobile/shared/services/network_checking_service.dart';
import 'package:route_pulse_mobile/shared/states/api_reponse.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientRemoteDatasource _clientRemoteDatasource =
      ClientRemoteDatasource();
  final ClientLocalDatasource _clientLocalDatasource = ClientLocalDatasource();
  final AuthRepositoryImpl _authRepository = AuthRepositoryImpl();

  @override
  Future<ApiResponse> searchClientsByName(String name) async {
    final bool isOnline = await NetworkCheckingService.checkInternet();
    final currentUser = await _authRepository.getCurrentUser();
    final String userId = currentUser.data['id'];

    if (!isOnline) {
      return await _searchClientsByNameLocally(name, userId);
    }

    try {
      final responseData = await _clientRemoteDatasource.searchClientsByName(
        name,
      );

      final clients = responseData['data']
          .map((client) => ClientDto.fromJson(client).toEntity())
          .toList();

      return ApiResponse(
        message: 'Clients récupérés avec succès.',
        data: clients,
      );
    } on DioException catch (err) {
      AppLogger.logger.e(
        'DioException while searching clients: ${err.response?.statusCode} - ${err.message} - ${err.error}',
      );

      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout ||
          err.type == DioExceptionType.connectionError) {
        return _searchClientsByNameLocally(name, userId);
      }

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
  Future<ApiResponse> getAllClients() async {
    final bool isOnline = await NetworkCheckingService.checkInternet();
  
    try {
      final responseData = await _clientRemoteDatasource.getAllClients();

      final clients = responseData['data']
          .map((client) => ClientDto.fromJson(client).toEntity())
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

  Future<ApiResponse> _searchClientsByNameLocally(
    String name,
    String userId,
  ) async {
    try {
      final clients = await _clientLocalDatasource.getClientByName(
        name,
        userId,
      );

      return ApiResponse(
        message: 'Résultats récupérés localement.',
        data: clients,
      );
    } catch (err) {
      AppLogger.logger.e('Error while searching clients locally: $err');

      return ApiResponse(
        hasError: true,
        message: 'Impossible de rechercher les clients. Veuillez réessayer.',
        errorType: NetworkErrorType.server,
      );
    }
  }

  @override
  Future<ApiResponse<Client>> createClient(
    CreateClientState data,
    bool checkName,
  ) async {
    final bool isOnline = await NetworkCheckingService.checkInternet();

    if (!isOnline) {
      return _createClientLocally(data);
    }

    try {
      final responseData = await _clientRemoteDatasource.createClient(
        data,
        checkName,
      );

      final client = ClientDto.fromJson(responseData['data']).toEntity();

      return ApiResponse(message: 'Client créé avec succès.', data: client);
    } on DioException catch (err) {
      AppLogger.logger.e(
        'DioException while creating client: ${err.response?.statusCode} - ${err.message} - ${err.error}',
      );

      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout ||
          err.type == DioExceptionType.connectionError) {
        return _createClientLocally(data);
      }

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

  Future<ApiResponse<Client>> _createClientLocally(
    CreateClientState data,
  ) async {
    try {
      final currentUser = await _authRepository.getCurrentUser();

      final client = await _clientLocalDatasource.saveNewClient(
        ClientHiveModel.fromMap(data.toMap(), currentUser.data['id']),
      );

      return ApiResponse(
        message: 'Client créé avec succès.',
        data: client?.toEntity(),
      );
    } catch (err) {
      AppLogger.logger.e('Error while creating client locally: $err');

      return ApiResponse(
        hasError: true,
        message: 'Impossible de créer le client. Veuillez réessayer.',
        errorType: NetworkErrorType.server,
      );
    }
  }
}

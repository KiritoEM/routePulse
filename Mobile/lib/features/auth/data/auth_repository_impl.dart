import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/utils/app_logger.dart';
import 'package:route_pulse_mobile/core/utils/network_error_handler.dart';
import 'package:route_pulse_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:route_pulse_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:route_pulse_mobile/features/auth/presentation/states/login_credentials_state.dart';
import 'package:route_pulse_mobile/shared/models/api_reponse.dart';
import 'package:route_pulse_mobile/shared/services/jwt_service.dart';
import 'package:route_pulse_mobile/shared/services/secure_storage_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatassource = AuthRemoteDatasource();

  @override
  Future<ApiResponse> login(LoginCredentialsState credentials) async {
    try {
      final loginResponse = await authRemoteDatassource.login(credentials);

      if (loginResponse.containsKey('accessToken')) {
        await SecureStorageService.write(
          'remote_acces_token',
          loginResponse['accessToken'],
        );

        final JWT remoteTokenPayload = JwtService.decodeToken(
          loginResponse['accessToken'],
        );


        // create and save local access access_token
        final String localToken = JwtService.createToken(
          payload: remoteTokenPayload.payload,
          expiresIn: Duration(days: 7),
        );

        await SecureStorageService.write('local_acces_token', localToken);
      }

      return ApiResponse(message: 'Connexion réussie !!!');
    } on DioException catch (err) {
      AppLogger.logger.e(
        'DioException while logging in: ${err.response?.statusCode} - ${err.message} - ${err.error}',
      );

      // handle incorrect crendentials
      if (err.response?.statusCode == 401) {
        return ApiResponse(
          hasError: true,
          message: 'Email ou mot de passe incorrect.',
          errorType: NetworkErrorType.conflict,
        );
      }

      if (err.response?.statusCode == 422) {
        return ApiResponse(
          hasError: true,
          message:
              err.response?.data['message'] ??
              'Données de connexion invalides.',
        );
      }

      return ApiResponse(
        hasError: true,
        message: NetworkErrorHandler.handleError(err)['message'],
        errorType:
            NetworkErrorHandler.handleError(err)['type'] as NetworkErrorType,
      );
    } catch (err) {
      AppLogger.logger.e('Error while logging in: $err');
      return ApiResponse(
        hasError: true,
        message:
            'Impossible de se connecter à votre compte. Veuillez réessayer.',
        errorType: NetworkErrorType.server,
      );
    }
  }
}

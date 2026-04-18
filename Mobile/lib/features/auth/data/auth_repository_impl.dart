import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/utils/app_logger.dart';
import 'package:route_pulse_mobile/core/utils/network_error_handler.dart';
import 'package:route_pulse_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:route_pulse_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:route_pulse_mobile/features/auth/presentation/states/login_credentials_state.dart';
import 'package:route_pulse_mobile/features/auth/presentation/states/signup_infos_credentials_state.dart';
import 'package:route_pulse_mobile/features/auth/presentation/states/validate_otp_credentials_state.dart';
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

  @override
  Future<ApiResponse> signupAddUserInfos(
    SignupInfosCredentialsState credentials,
  ) async {
    try {
      final signupResponse = await authRemoteDatassource.signupAddUserInfos(
        credentials,
      );

      return ApiResponse(
        message: signupResponse['message'],
        data: signupResponse['verificationToken'],
      );
    } on DioException catch (err) {
      AppLogger.logger.e(
        'DioException while sending user informations: ${err.response?.statusCode} - ${err.message} - ${err.error}',
      );

      if (err.response?.statusCode == 409) {
        return ApiResponse(
          hasError: true,
          message: err.response?.data['message'],
          errorType: .conflict,
        );
      }

      if (err.response?.statusCode == 429) {
        return ApiResponse(
          hasError: true,
          message: err.response?.data['message'],
          errorType: .tooManyRequest,
        );
      }

      if (err.response?.statusCode == 422) {
        return ApiResponse(
          hasError: true,
          message:
              err.response?.data['message'] ??
              'Informations personnelles invalides.',
        );
      }

      return ApiResponse(
        hasError: true,
        message: NetworkErrorHandler.handleError(err)['message'],
        errorType:
            NetworkErrorHandler.handleError(err)['type'] as NetworkErrorType,
      );
    } catch (err) {
      AppLogger.logger.e('Error while sending user informations: $err');
      return ApiResponse(
        hasError: true,
        message:
            "Une erreur est survenue lors de l'inscription. Veuillez réessayer.",
        errorType: NetworkErrorType.server,
      );
    }
  }

  @override
  Future<ApiResponse> validateSignupOtp(
    ValidateOtpCredentialsState credentials,
  ) async {
    try {
      final signupResponse = await authRemoteDatassource.validateSignupOtp(
        credentials,
      );

      return ApiResponse(message: signupResponse['message']);
    } on DioException catch (err) {
      AppLogger.logger.e(
        'DioException while validating OTP: ${err.response?.statusCode} - ${err.message} - ${err.error}',
      );
      if (err.response?.statusCode == 401) {
        return ApiResponse(
          hasError: true,
          message: err.response?.data['message'],
          errorType: .unauthorized,
        );
      }
      if (err.response?.statusCode == 429) {
        return ApiResponse(
          hasError: true,
          message: err.response?.data['message'],
          errorType: .tooManyRequest,
        );
      }

      if (err.response?.statusCode == 422) {
        return ApiResponse(
          hasError: true,
          message:
              err.response?.data['message'] ?? "Le code saisi est invalide.",
        );
      }
      return ApiResponse(
        hasError: true,
        message: NetworkErrorHandler.handleError(err)['message'],
        errorType:
            NetworkErrorHandler.handleError(err)['type'] as NetworkErrorType,
      );
    } catch (err) {
      AppLogger.logger.e('Error while validating OTP: $err');

      return ApiResponse(
        hasError: true,
        message:
            "Une erreur est survenue lors de la vérification du code. Veuillez réessayer.",
        errorType: NetworkErrorType.server,
      );
    }
  }

  @override
  Future<ApiResponse> resendSignupOtp(credentials) async {
    try {
      final signupResponse = await authRemoteDatassource.resendSignupOtp(
        credentials,
      );

      return ApiResponse(
        message:
            signupResponse['message'] ??
            "Un nouveau code de vérification a été envoyé.",
      );
    } on DioException catch (err) {
      AppLogger.logger.e(
        'DioException while resending OTP: ${err.response?.statusCode} - ${err.message} - ${err.error}',
      );

      if (err.response?.statusCode == 401) {
        return ApiResponse(
          hasError: true,
          message:
              err.response?.data['message'],
          errorType: NetworkErrorType.unauthorized,
        );
      }

      if (err.response?.statusCode == 429) {
        return ApiResponse(
          hasError: true,
          message:
              err.response?.data['message'],
          errorType: NetworkErrorType.tooManyRequest,
        );
      }

      if (err.response?.statusCode == 422) {
        return ApiResponse(
          hasError: true,
          message:
              err.response?.data['message'] ??
              "Impossible d'envoyer un nouveau code. Veuillez vérifier vos informations.",
        );
      }

      return ApiResponse(
        hasError: true,
        message: NetworkErrorHandler.handleError(err)['message'],
        errorType:
            NetworkErrorHandler.handleError(err)['type'] as NetworkErrorType,
      );
    } catch (err) {
      AppLogger.logger.e('Error while resending OTP: $err');

      return ApiResponse(
        hasError: true,
        message:
            "Une erreur est survenue lors de l'envoi du code. Veuillez réessayer.",
        errorType: NetworkErrorType.server,
      );
    }
  }
}

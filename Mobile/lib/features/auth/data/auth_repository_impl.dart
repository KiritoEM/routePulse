import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/constants/key_constant.dart';
import 'package:route_pulse_mobile/core/utils/app_logger.dart';
import 'package:route_pulse_mobile/core/utils/hashing_utils.dart';
import 'package:route_pulse_mobile/core/utils/network_error_handler.dart';
import 'package:route_pulse_mobile/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:route_pulse_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:route_pulse_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:route_pulse_mobile/features/auth/presentation/states/create_password_credentials_state.dart';
import 'package:route_pulse_mobile/features/auth/presentation/states/login_credentials_state.dart';
import 'package:route_pulse_mobile/features/auth/presentation/states/signup_infos_credentials_state.dart';
import 'package:route_pulse_mobile/features/auth/presentation/states/validate_otp_credentials_state.dart';
import 'package:route_pulse_mobile/features/user/domain/entities/user.dart';
import 'package:route_pulse_mobile/shared/services/network_checking_service.dart';
import 'package:route_pulse_mobile/shared/states/api_reponse.dart';
import 'package:route_pulse_mobile/shared/services/jwt_service.dart';
import 'package:route_pulse_mobile/shared/services/secure_storage_service.dart';
import 'package:route_pulse_mobile/shared/states/jwt_result.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _authRemoteDataSource = AuthRemoteDatasource();
  final AuthLocalDatasource _authLocalDataSource = AuthLocalDatasource();

  final String _KUser = 'active_user';
  final String _KLocalAccessToken = 'local_acces_token';
  final String _KRemoteRefreshToken = 'remote_refresh_token';

  Future _saveLocalToken(Map<String, dynamic> payload) async {
    final String localToken = JwtService.createToken(
      payload: payload,
      expiresIn: Duration(days: 7),
    );

    await SecureStorageService.write(_KLocalAccessToken, localToken);
  }

  Future _saveTokens(
    String accessToken, {
    bool? isBiometric,
    String? refreshToken,
  }) async {
    await SecureStorageService.write(KeyConstant.kRemoteAccessToken, accessToken);

    if (refreshToken != null) {
      await SecureStorageService.write(_KRemoteRefreshToken, refreshToken);
    }

    final JWT remoteTokenPayload = JwtService.decodeToken(accessToken);

    // create and save local access access_token
    await _saveLocalToken(remoteTokenPayload.payload);

    // save user to secure_storage
    if (isBiometric != null && !isBiometric) {
      await SecureStorageService.write(
        _KUser,
        jsonEncode({
          'id': remoteTokenPayload.payload['id'],
          'email': remoteTokenPayload.payload['email'],
        }),
      );
    }
  }

  @override
  Future<ApiResponse> login(LoginCredentialsState credentials) async {
    final bool isOnline = await NetworkCheckingService.checkInternet();

    // use login offline if no connection
    if (!isOnline) {
      return await _loginOffline(credentials);
    }

    try {
      final loginResponse = await _authRemoteDataSource.login(credentials);

      if (loginResponse.containsKey('accessToken') &&
          loginResponse.containsKey('refreshToken')) {
        await _saveTokens(
          loginResponse['accessToken'],
          refreshToken: loginResponse['refreshToken'],
        );
      }

      return ApiResponse(message: 'Connexion réussie !!!');
    } on DioException catch (err) {
      AppLogger.logger.e(
        'DioException while logging in: ${err.response?.statusCode} - ${err.message} - ${err.error}',
      );

      // handle incorrect crendentials
      if (err.response?.statusCode == 401) {
        return ApiResponse(
          hasError: true,
          message: 'Mot de passe incorrect.',
          errorType: NetworkErrorType.conflict,
        );
      }

      // handle not found email
      if (err.response?.statusCode == 404) {
        return ApiResponse(
          hasError: true,
          message: 'Email incorrect.',
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

      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout ||
          err.type == DioExceptionType.connectionError) {
        return await _loginOffline(credentials);
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
            'Impossible de se connecter à votre compte. Veuillez réessayer.',
        errorType: NetworkErrorType.server,
      );
    }
  }

  Future<ApiResponse> _loginOffline(LoginCredentialsState credentials) async {
    try {
      final user = _authLocalDataSource.getUserByEmail(credentials.email);

      if (user == null) {
        return ApiResponse(
          hasError: true,
          message: 'Email incorrect.',
          errorType: NetworkErrorType.unauthorized,
        );
      }

      final isPasswordMatched = HashingUtils.verify(
        credentials.password,
        user.password,
      );

      if (!isPasswordMatched) {
        return ApiResponse(
          hasError: true,
          message: 'Mot de passe incorrect.',
          errorType: NetworkErrorType.unauthorized,
        );
      }

      await _saveLocalToken({
        'id': user.id,
        'email': user.email,
        'biometricEnabled': user.biometricEnabled,
      });

      final storedActiveUser = await SecureStorageService.read(_KUser);
      if (storedActiveUser == null) {
        await SecureStorageService.write(
          _KUser,
          jsonEncode({'id': user.id, 'email': user.email}),
        );
      }

      return ApiResponse(message: 'Connexion hors ligne réussie.');
    } catch (err) {
      AppLogger.logger.e('Error while logging in: $err');
      return ApiResponse(
        hasError: true,
        message:
            'Impossible de se connecter à votre compte. Veuillez réessayer.',
        errorType: NetworkErrorType.server,
      );
    }
  }

  @override
  Future<ApiResponse> loginWithBiometric() async {
    final bool isOnline = await NetworkCheckingService.checkInternet();

    // use login offline if no connection
    if (!isOnline) {
      return await _loginWithBiometricOffline();
    }

    try {
      final userJson = await SecureStorageService.read(_KUser);

      if (userJson == null) {
        return ApiResponse(
          hasError: true,
          message:
              'Impossible de se connecter par biométrie. Veuillez vous connecter par formulaire',
        );
      }

      final user = jsonDecode(userJson);
      final loginResponse = await _authRemoteDataSource.loginWithBiometric(
        user['id'],
      );

      if (loginResponse.containsKey('accessToken') &&
          loginResponse.containsKey('refreshToken')) {
        await _saveTokens(
          loginResponse['accessToken'],
          refreshToken: loginResponse['refreshToken'],
          isBiometric: true,
        );
      }

      return ApiResponse(message: 'Connexion avec biometrie réussie !!!');
    } on DioException catch (err) {
      AppLogger.logger.e(
        'DioException while logging with biometric in: ${err.response?.statusCode} - ${err.message} - ${err.error}',
      );

      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout ||
          err.type == DioExceptionType.connectionError) {
        return await _loginWithBiometricOffline();
      }

      return ApiResponse(
        hasError: true,
        message:
            'Impossible de se connecter par biométrie. Veuillez vous connecter par formulaire',
        errorType:
            NetworkErrorHandler.handleError(err)['type'] as NetworkErrorType,
      );
    } catch (err) {
      AppLogger.logger.e('Error while logging in: $err');
      return ApiResponse(
        hasError: true,
        message:
            'Impossible de se connecter par biométrie. Veuillez vous connecter par formulaire',
        errorType: NetworkErrorType.server,
      );
    }
  }

  Future<ApiResponse> _loginWithBiometricOffline() async {
    try {
      // get current user stored in device
      final currentUser = await SecureStorageService.read(_KUser);

      if (currentUser == null) {
        return ApiResponse(
          hasError: true,
          message:
              'Aucun utilisateur trouvé sur cet appareil. Veuillez vous connecter par formulaire.',
          errorType: NetworkErrorType.unauthorized,
        );
      }
      final decodeCurrentUser = jsonDecode(currentUser);

      final user = _authLocalDataSource.getUserById(decodeCurrentUser['id']);

      if (user == null) {
        return ApiResponse(
          hasError: true,
          message:
              'Vos données locales sont introuvables. Veuillez vous connecter par formulaire.',
          errorType: NetworkErrorType.unauthorized,
        );
      }
      await _saveLocalToken({
        'id': user.id,
        'email': user.email,
        'biometricEnabled': user.biometricEnabled,
      });

      return ApiResponse(message: 'Connexion biométrique hors ligne réussie.');
    } catch (err) {
      AppLogger.logger.e('Error while logging in: $err');
      return ApiResponse(
        hasError: true,
        message:
            'Impossible de se connecter par biométrie. Veuillez vous connecter par formulaire.',
        errorType: NetworkErrorType.server,
      );
    }
  }

  @override
  Future<ApiResponse> signupAddUserInfos(
    SignupInfosCredentialsState credentials,
  ) async {
    try {
      final signupResponse = await _authRemoteDataSource.signupAddUserInfos(
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
          errorType: NetworkErrorType.conflict,
        );
      }

      if (err.response?.statusCode == 429) {
        return ApiResponse(
          hasError: true,
          message: err.response?.data['message'],
          errorType: NetworkErrorType.tooManyRequest,
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
      final validateOtpResponse = await _authRemoteDataSource.validateSignupOtp(
        credentials,
      );

      return ApiResponse(
        message: validateOtpResponse['message'],
        data: validateOtpResponse['creationToken'],
      );
    } on DioException catch (err) {
      AppLogger.logger.e(
        'DioException while validating OTP: ${err.response?.statusCode} - ${err.message} - ${err.error}',
      );
      if (err.response?.statusCode == 401) {
        return ApiResponse(
          hasError: true,
          message: err.response?.data['message'],
          errorType: NetworkErrorType.unauthorized,
        );
      }

       if (err.response?.statusCode == 400) {
        return ApiResponse(
          hasError: true,
          message: err.response?.data['message'],
          errorType: NetworkErrorType.badRequest,
        );
      }

      if (err.response?.statusCode == 429) {
        return ApiResponse(
          hasError: true,
          message: err.response?.data['message'],
          errorType: NetworkErrorType.tooManyRequest,
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
      final resendOtpResponse = await _authRemoteDataSource.resendSignupOtp(
        credentials,
      );

      return ApiResponse(
        message: "Un nouveau code de vérification a été envoyé.",
        data: resendOtpResponse['verificationToken'],
      );
    } on DioException catch (err) {
      AppLogger.logger.e(
        'DioException while resending OTP: ${err.response?.statusCode} - ${err.message} - ${err.error}',
      );

      if (err.response?.statusCode == 401) {
        return ApiResponse(
          hasError: true,
          message: err.response?.data['message'],
          errorType: NetworkErrorType.unauthorized,
        );
      }

      if (err.response?.statusCode == 429) {
        return ApiResponse(
          hasError: true,
          message: err.response?.data['message'],
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

  @override
  Future<ApiResponse> createPassword(
    CreatePasswordCredentialsState credentials,
  ) async {
    try {
      final createPasswordResponse = await _authRemoteDataSource.createPassword(
        credentials,
      );
      final data = createPasswordResponse['data'];
      final user = Map<String, dynamic>.from({
        ...data['user'] as Map,
        'password': HashingUtils.hashString(credentials.password),
      });

      // save user to local DB
      _authLocalDataSource.saveNewUser(User.fromJson(user));

      // save user to secure_storage
      await SecureStorageService.write(
        _KUser,
        jsonEncode({'id': user['id'], 'email': user['email']}),
      );

      await _saveTokens(data['accessToken']);
      return ApiResponse(message: createPasswordResponse['message']);
    } on DioException catch (err) {
      AppLogger.logger.e(
        'DioException while creating password: ${err.response?.statusCode} - ${err.message} - ${err.error}',
      );

      if (err.response?.statusCode == 401) {
        return ApiResponse(
          hasError: true,
          message: err.response?.data['message'],
          errorType: NetworkErrorType.unauthorized,
        );
      }

      if (err.response?.statusCode == 422) {
        return ApiResponse(
          hasError: true,
          message:
              err.response?.data['message'] ??
              "Le mot de passe fourni est invalide. Veuillez réessayer.",
        );
      }

      return ApiResponse(
        hasError: true,
        errorType:
            NetworkErrorHandler.handleError(err)['type'] as NetworkErrorType,
      );
    } catch (err) {
      AppLogger.logger.e('Error while creating password: $err');

      return ApiResponse(
        hasError: true,
        message:
            "Une erreur est survenue lors de la création du mot de passe. Veuillez réessayer.",
        errorType: NetworkErrorType.server,
      );
    }
  }

  @override
  Future<ApiResponse> checkIsBiometricEnabled() async {
    try {
      // decode remote/local Jwt token
      final bool isOnline = await NetworkCheckingService.checkInternet();
      late bool biometricEnabled;

      if (!isOnline) {
        final payload = await _decodeLocalToken();

        if (payload == null) {
          return ApiResponse(
            hasError: true,
            errorType: NetworkErrorType.unauthorized,
          );
        }
        biometricEnabled = payload['biometricEnabled'];
      } else {
        final payload = await _decodeRemoteToken();

        if (payload == null) {
          return ApiResponse(
            hasError: true,
            errorType: NetworkErrorType.unauthorized,
          );
        }

        biometricEnabled = payload['biometricEnabled'];
      }

      return ApiResponse(data: biometricEnabled);
    } catch (err) {
      AppLogger.logger.e('Error when checking if biometric is enabled: $err');

      return ApiResponse(hasError: true, errorType: NetworkErrorType.server);
    }
  }

  Future<Map<String, dynamic>?> _decodeRemoteToken() async {
    final token = await SecureStorageService.read(KeyConstant.kRemoteAccessToken);

    if (token == null) return null;

    final JWT remoteTokenPayload = await JwtService.decodeToken(token);

    return remoteTokenPayload.payload;
  }

  Future<Map<String, dynamic>?> _decodeLocalToken() async {
    final token = await SecureStorageService.read(_KLocalAccessToken);

    if (token == null) return null;

    final JwtResult jwtResult = await JwtService.verifyToken(token);

    if (jwtResult.result != JwtVerifyResult.success) {
      return null;
    }

    return jwtResult.payload;
  }

  @override
  Future<ApiResponse> refreshToken() async {
    try {
      final token = await SecureStorageService.read(_KRemoteRefreshToken);

      if (token == null) {
        return ApiResponse(
          hasError: true,
          message: 'Aucun token trouvé. Veuillez vous reconnecter.',
          errorType: NetworkErrorType.unauthorized,
        );
      }

      final refreshResponse = await _authRemoteDataSource.refreshToken(token);

      if (refreshResponse.containsKey('accessToken')) {
        await _saveTokens(refreshResponse['accessToken']);
      }

      return ApiResponse(
        message: 'Token rafraîchi avec succès.',
        data: refreshResponse['accessToken'],
      );
    } on DioException catch (err) {
      AppLogger.logger.e(
        'DioException while refreshing token: ${err.response?.statusCode} - ${err.message} - ${err.error}',
      );

      if (err.response?.statusCode == 401) {
        return ApiResponse(
          hasError: true,
          message: 'Session expirée. Veuillez vous reconnecter.',
          errorType: NetworkErrorType.unauthorized,
        );
      }

      if (err.response?.statusCode == 422) {
        return ApiResponse(
          hasError: true,
          message: err.response?.data['message'] ?? 'Token invalide.',
          errorType: NetworkErrorType.unauthorized,
        );
      }

      return ApiResponse(
        hasError: true,
        message: NetworkErrorHandler.handleError(err)['message'],
        errorType:
            NetworkErrorHandler.handleError(err)['type'] as NetworkErrorType,
      );
    } catch (err) {
      AppLogger.logger.e('Error while refreshing token: $err');
      return ApiResponse(
        hasError: true,
        message:
            'Impossible de rafraîchir la session. Veuillez vous reconnecter.',
        errorType: NetworkErrorType.server,
      );
    }
  }
}

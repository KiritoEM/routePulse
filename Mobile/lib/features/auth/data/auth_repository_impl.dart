import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/constants/key_constant.dart';
import 'package:route_pulse_mobile/core/local_db/models/user_model.dart';
import 'package:route_pulse_mobile/core/utils/app_logger.dart';
import 'package:route_pulse_mobile/core/utils/hashing_utils.dart';
import 'package:route_pulse_mobile/core/utils/network_error_handler.dart';
import 'package:route_pulse_mobile/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:route_pulse_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:route_pulse_mobile/features/auth/data/models/auth_dto.dart';
import 'package:route_pulse_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:route_pulse_mobile/features/auth/presentation/states/create_password_credentials_state.dart';
import 'package:route_pulse_mobile/features/auth/presentation/states/login_credentials_state.dart';
import 'package:route_pulse_mobile/features/auth/presentation/states/signup_infos_credentials_state.dart';
import 'package:route_pulse_mobile/features/auth/presentation/states/validate_otp_credentials_state.dart';
import 'package:route_pulse_mobile/shared/services/network_checking_service.dart';
import 'package:route_pulse_mobile/shared/states/api_reponse.dart';
import 'package:route_pulse_mobile/shared/services/jwt_service.dart';
import 'package:route_pulse_mobile/shared/services/secure_storage_service.dart';
import 'package:route_pulse_mobile/shared/services/session_service.dart';
import 'package:route_pulse_mobile/shared/states/jwt_result.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _authRemoteDataSource = AuthRemoteDatasource();
  final AuthLocalDatasource _authLocalDataSource = AuthLocalDatasource();

  final String _KUser = KeyConstant.kActiveUser;
  final String _KLocalAccessToken = KeyConstant.kLocalAccessToken;
  final String _KRemoteRefreshToken = KeyConstant.kRemoteRefreshToken;

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
        final payload = await _saveTokens(
          loginResponse['accessToken'],
          refreshToken: loginResponse['refreshToken'],
        );

        // mirror user localy to keep offline and biometric login working
        await _cacheUserLocally(payload, credentials.password);
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

      final payload = {
        'id': user.id,
        'email': user.email,
        'biometricEnabled': user.biometricEnabled,
      };

      await _saveLocalToken(payload);
      await _saveActiveUser(payload);

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
    // get active user kept on device after logout
    final activeUser = await _readActiveUser();

    if (activeUser == null) {
      return ApiResponse(
        hasError: true,
        message:
            'Aucun utilisateur trouvé sur cet appareil. Veuillez vous connecter par formulaire.',
        errorType: NetworkErrorType.unauthorized,
      );
    }

    if (activeUser['biometricEnabled'] != true) {
      return ApiResponse(
        hasError: true,
        message:
            'La biométrie n\'est pas activée sur ce compte. Veuillez vous connecter par formulaire.',
        errorType: NetworkErrorType.unauthorized,
      );
    }

    final bool isOnline = await NetworkCheckingService.checkInternet();

    // use login offline if no connection
    if (!isOnline) {
      return await _loginWithBiometricOffline(activeUser['id']);
    }

    try {
      final loginResponse = await _authRemoteDataSource.loginWithBiometric(
        activeUser['id'],
      );

      if (loginResponse.containsKey('accessToken') &&
          loginResponse.containsKey('refreshToken')) {
        final payload = await _saveTokens(
          loginResponse['accessToken'],
          refreshToken: loginResponse['refreshToken'],
        );

        await _authLocalDataSource.updateBiometricEnabled(
          payload['id'],
          payload['biometricEnabled'] == true,
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
        return await _loginWithBiometricOffline(activeUser['id']);
      }

      // biometric refused by backend: disable it on device
      if (err.response?.statusCode == 401 || err.response?.statusCode == 404) {
        await _disableBiometricLocally(activeUser['id']);

        return ApiResponse(
          hasError: true,
          message:
              err.response?.data['message'] ??
              'Connexion biométrique refusée. Veuillez vous connecter par formulaire.',
          errorType: NetworkErrorType.unauthorized,
        );
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

  Future<ApiResponse> _loginWithBiometricOffline(String userId) async {
    try {
      final user = _authLocalDataSource.getUserById(userId);

      if (user == null) {
        return ApiResponse(
          hasError: true,
          message:
              'Vos données locales sont introuvables. Veuillez vous connecter par formulaire.',
          errorType: NetworkErrorType.unauthorized,
        );
      }

      if (!user.biometricEnabled) {
        return ApiResponse(
          hasError: true,
          message:
              'La biométrie n\'est pas activée sur ce compte. Veuillez vous connecter par formulaire.',
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
      await _authLocalDataSource.saveNewUser(
        SignupDto.fromJson(user).toHiveModel(),
      );

      await _saveTokens(
        data['accessToken'],
        refreshToken: data['refreshToken'],
      );

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
      // read the flag on the active user, it survives the logout
      final activeUser = await _readActiveUser();

      if (activeUser == null) return ApiResponse(data: false);

      if (activeUser.containsKey('biometricEnabled')) {
        return ApiResponse(data: activeUser['biometricEnabled'] == true);
      }

      // fallback on local DB for accounts saved before the sync
      final user = _authLocalDataSource.getUserById(activeUser['id']);

      return ApiResponse(data: user?.biometricEnabled ?? false);
    } catch (err) {
      AppLogger.logger.e('Error when checking if biometric is enabled: $err');

      return ApiResponse(data: false);
    }
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

  @override
  Future<ApiResponse> getCurrentUser() async {
    try {
      // decode remote/local Jwt token
      final bool isOnline = await NetworkCheckingService.checkInternet();
      Map<String, dynamic>? payload = isOnline
          ? await _decodeRemoteToken()
          : await _decodeLocalToken();

      // access token expired: try to restore the session before giving up
      if (payload == null && isOnline) {
        final refreshResponse = await refreshToken();

        if (refreshResponse.isSucess) {
          payload = await _decodeRemoteToken();
        }
      }

      // session is dead: clear it and back to login
      if (payload == null) {
        await SessionService.expireSession();

        return ApiResponse(
          hasError: true,
          message: 'Session expirée. Veuillez vous reconnecter.',
          errorType: NetworkErrorType.unauthorized,
        );
      }

      return ApiResponse(data: payload);
    } catch (err) {
      AppLogger.logger.e(
        'Error when fetching current user in JWT session: $err',
      );

      return ApiResponse(hasError: true, errorType: NetworkErrorType.server);
    }
  }

  Future _saveLocalToken(Map<String, dynamic> payload) async {
    final String localToken = JwtService.createToken(
      payload: payload,
      expiresIn: Duration(days: 7),
    );

    await SecureStorageService.write(_KLocalAccessToken, localToken);
  }

  Future<Map<String, dynamic>> _saveTokens(
    String accessToken, {
    String? refreshToken,
  }) async {
    await SecureStorageService.write(
      KeyConstant.kRemoteAccessToken,
      accessToken,
    );

    if (refreshToken != null) {
      await SecureStorageService.write(_KRemoteRefreshToken, refreshToken);
    }

    final JWT remoteTokenPayload = JwtService.decodeToken(accessToken);
    final Map<String, dynamic> payload = Map<String, dynamic>.from(
      remoteTokenPayload.payload,
    );

    // create and save local access access_token
    await _saveLocalToken(payload);

    // save user to secure_storage
    await _saveActiveUser(payload);

    return payload;
  }

  // active user is kept after logout to allow biometric login
  Future _saveActiveUser(Map<String, dynamic> payload) async {
    await SecureStorageService.write(
      _KUser,
      jsonEncode({
        'id': payload['id'],
        'email': payload['email'],
        'biometricEnabled': payload['biometricEnabled'] == true,
      }),
    );
  }

  Future<Map<String, dynamic>?> _readActiveUser() async {
    final userJson = await SecureStorageService.read(_KUser);

    if (userJson == null) return null;

    return jsonDecode(userJson) as Map<String, dynamic>;
  }

  Future _cacheUserLocally(
    Map<String, dynamic> payload,
    String password,
  ) async {
    final existingUser = _authLocalDataSource.getUserById(payload['id']);

    await _authLocalDataSource.saveNewUser(
      UserHiveModel(
        id: payload['id'],
        email: payload['email'],
        password: HashingUtils.hashString(password),
        biometricEnabled: payload['biometricEnabled'] == true,
        createdAt: existingUser?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future _disableBiometricLocally(String userId) async {
    final activeUser = await _readActiveUser();

    if (activeUser != null) {
      await _saveActiveUser({...activeUser, 'biometricEnabled': false});
    }

    await _authLocalDataSource.updateBiometricEnabled(userId, false);
  }

  Future<Map<String, dynamic>?> _decodeRemoteToken() async {
    final token = await SecureStorageService.read(
      KeyConstant.kRemoteAccessToken,
    );

    if (token == null) return null;

    final bool isTokenExpired = JwtService.checkExpiry(token);

    if (isTokenExpired) {
      return null;
    }

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
  Future<ApiResponse> logout() async {
    try {
      await SecureStorageService.delete(KeyConstant.kRemoteAccessToken);
      await SecureStorageService.delete(_KRemoteRefreshToken);
      await SecureStorageService.delete(_KLocalAccessToken);

      return ApiResponse(message: 'Déconnexion réussie.');
    } catch (err) {
      AppLogger.logger.e('Error while logging out: $err');
      return ApiResponse(
        hasError: true,
        message: 'Impossible de se déconnecter. Veuillez réessayer.',
        errorType: NetworkErrorType.server,
      );
    }
  }
}

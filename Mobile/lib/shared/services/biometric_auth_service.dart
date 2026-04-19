// ignore_for_file: empty_constructor_bodies

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:route_pulse_mobile/core/utils/app_logger.dart';
import 'package:route_pulse_mobile/shared/models/api_reponse.dart';
import 'package:local_auth_android/local_auth_android.dart';

class BiometricAuthService {
  //singleton
  static final BiometricAuthService _instance =
      BiometricAuthService._internal();
  factory BiometricAuthService() => _instance;
  BiometricAuthService._internal();

  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> checkIsBiometricSupported() async {
    return await _auth.isDeviceSupported();
  }

  static Future<bool> checkBiometrics() async {
    late bool canCheckBiometrics;

    try {
      canCheckBiometrics = await _auth.canCheckBiometrics;
    } on PlatformException catch (err) {
      canCheckBiometrics = false;
      AppLogger.logger.e(
        'An error was occured when verifying if device can check biometrics: $err',
      );
    }

    return canCheckBiometrics;
  }

  static Future<List<BiometricType>> getAvalaibleBiometrics() async {
    late List<BiometricType> availableBiometrics;

    try {
      availableBiometrics = await _auth.getAvailableBiometrics();
    } on PlatformException catch (err) {
      availableBiometrics = <BiometricType>[];
      AppLogger.logger.e(
        'An error was occured when getting available biometrics method: $err',
      );
    }

    return availableBiometrics;
  }

  // Authenticate using biometric only
  static Future<ApiResponse> authenticate() async {
    try {
      final bool authenticated = await _auth.authenticate(
        localizedReason:
            'Utilisez la biométrie de votre appareil pour accéder à votre compte.',
        authMessages: [
          AndroidAuthMessages(
            signInTitle: 'Connexion sécurisée',
            cancelButton: 'Annuler',
            signInHint: '',
          ),
        ],
        persistAcrossBackgrounding: true,
        biometricOnly: true,
      );

      return ApiResponse(
        message: authenticated
            ? 'Authentification biométrique réussie.'
            : 'Authentification échouée. Veuillez réessayer.',
        data: authenticated,
      );
    } on LocalAuthException catch (err) {
      AppLogger.logger.e(
        '[LocalAuthException] An error was occured during authentication: $err',
      );

      if (err.code == LocalAuthExceptionCode.userCanceled ||
          err.code == LocalAuthExceptionCode.systemCanceled) {
        return ApiResponse(data: false);
      }

      return ApiResponse(
        message:
            'Une erreur est survenue lors de l\'authentification. Veuillez réessayer.',
        hasError: true,
      );
    } on PlatformException catch (err) {
      AppLogger.logger.e(
        '[PlatformException] An error was occured during authentication: $err',
      );
      return ApiResponse(
        message:
            'Une erreur système inattendue s\'est produite. Veuillez contacter le support.',
        hasError: true,
      );
    }
  }

  // Properly cance authentication
  static Future cancelAuthentication() async {
    await _auth.stopAuthentication();
  }
}

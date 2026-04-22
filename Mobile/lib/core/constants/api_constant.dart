// ignore_for_file: constant_identifier_names

class ApiConstant {
  // Timeouts
  static const Duration CONNECT_TIMEOUT = Duration(seconds: 30);
  static const Duration RECEIVE_TIMEOUT = Duration(seconds: 30);
  static const Duration SEND_TIMEOUT = Duration(seconds: 30);

  // Headers
  static const Map<String, String> HEADERS = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'ngrok-skip-browser-warning': 'true',
  };

  // Endpoints
  static const String LOGIN_ENDPOINT = '/auth/login';
  static const String BIOMETRIC_LOGIN_ENDPOINT = '/auth/biometric-login';
  static const String SIGNUP_ENDPOINT = '/auth/register';
  static const String SIGNUP_ADD_INFOS_ENDPOINT = '$SIGNUP_ENDPOINT/send-otp';
  static const String VALIDATE_SIGNUP_OTP_ENDPOINT =
      '$SIGNUP_ENDPOINT/validate-otp';
  static const String RESEND_SIGNUP_OTP_ENDPOINT =
      '$SIGNUP_ENDPOINT/resend-otp';
  static const String SIGNUP_CREATE_PASSWORD_ENDPOINT =
      '$SIGNUP_ENDPOINT/create-password';
  static const String REFRESH_TOKEN_ENDPOINT =
      '$SIGNUP_ENDPOINT/refresh-token';
  static const String DELIVERIES_ENDPOINT = '/delivery';
}

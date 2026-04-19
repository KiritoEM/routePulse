import 'package:route_pulse_mobile/features/auth/presentation/states/create_password_credentials_state.dart';
import 'package:route_pulse_mobile/features/auth/presentation/states/login_credentials_state.dart';
import 'package:route_pulse_mobile/features/auth/presentation/states/signup_infos_credentials_state.dart';
import 'package:route_pulse_mobile/features/auth/presentation/states/validate_otp_credentials_state.dart';
import 'package:route_pulse_mobile/shared/states/api_reponse.dart';
import 'package:route_pulse_mobile/shared/states/resend_otp_credentials_state.dart';

abstract class AuthRepository {
  Future<ApiResponse> login(LoginCredentialsState credentials);
  Future<ApiResponse> loginWithBiometric();
  Future<ApiResponse> signupAddUserInfos(
    SignupInfosCredentialsState credentials,
  );
  Future<ApiResponse> validateSignupOtp(
    ValidateOtpCredentialsState credentials,
  );
  Future<ApiResponse> resendSignupOtp(ResendOtpCredentialsState credentials);
  Future<ApiResponse> createPassword(
    CreatePasswordCredentialsState credentials,
  );
  Future<ApiResponse> checkIsBiometricEnabled();
}

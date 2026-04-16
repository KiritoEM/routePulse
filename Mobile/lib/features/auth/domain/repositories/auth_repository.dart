import 'package:route_pulse_mobile/features/auth/presentation/states/login_credentials_state.dart';
import 'package:route_pulse_mobile/features/auth/presentation/states/signup_infos_credentials_state.dart';
import 'package:route_pulse_mobile/shared/models/api_reponse.dart';

abstract class AuthRepository {
  Future<ApiResponse> login(LoginCredentialsState credentials);
  Future<ApiResponse> signupAddUserInfos(SignupInfosCredentialsState credentials);
}

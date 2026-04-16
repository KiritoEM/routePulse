import 'package:route_pulse_mobile/core/constants/api_constant.dart';
import 'package:route_pulse_mobile/core/network/dio_config.dart';
import 'package:route_pulse_mobile/features/auth/presentation/states/login_credentials_state.dart';
import 'package:route_pulse_mobile/features/auth/presentation/states/signup_infos_credentials_state.dart';

class AuthRemoteDatasource {
  final _dio = DioConfig.instance;

  Future<Map<String, dynamic>> login(LoginCredentialsState credentials) async {
    final response = await _dio.post(
      ApiConstant.LOGIN_ENDPOINT,
      data: credentials.toJson(),
    );

    return response.data;
  }

  Future<Map<String, dynamic>> signupAddUserInfos(SignupInfosCredentialsState credentials) async {
    final response = await _dio.post(
      ApiConstant.SIGNUP_ADD_INFOS_ENDPOINT,
      data: credentials.toJson(),
    );

    return response.data;
  }
}

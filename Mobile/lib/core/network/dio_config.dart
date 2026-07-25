import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:route_pulse_mobile/core/constants/api_constant.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';
import 'package:route_pulse_mobile/core/constants/key_constant.dart';
import 'package:route_pulse_mobile/core/utils/app_logger.dart';
import 'package:route_pulse_mobile/features/auth/data/auth_repository_impl.dart';
import 'package:route_pulse_mobile/shared/services/secure_storage_service.dart';
import 'package:route_pulse_mobile/shared/services/session_service.dart';

class DioConfig {
  static final String _baseUrl = dotenv.env['API_BASE_URL']!;
  static final AuthRepositoryImpl _authRepository = AuthRepositoryImpl();

  // Singleton
  static final DioConfig _instance = DioConfig._internal();
  factory DioConfig() => _instance;
  DioConfig._internal();

  static Dio? _dio;

  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: ApiConstant.CONNECT_TIMEOUT,
        receiveTimeout: ApiConstant.RECEIVE_TIMEOUT,
        sendTimeout: ApiConstant.SEND_TIMEOUT,
        responseType: ResponseType.json,
        headers: ApiConstant.HEADERS,
      ),
    );

    //  Request Interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorageService.read(KeyConstant.kRemoteAccessToken);

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onError: (error, handler) async {
          // auth endpoints never need a token refresh
          final isAuthRequest = error.requestOptions.path.contains(
            ApiConstant.AUTH_ENDPOINT,
          );

          if (error.response?.statusCode == 401 && !isAuthRequest) {
            final response = await _authRepository.refreshToken();

            if (response.hasError == true) {
              AppLogger.logger.e(response.message);

              // refresh impossible: end session and back to login
              if (response.errorType == NetworkErrorType.unauthorized) {
                await SessionService.expireSession();
              }

              return handler.next(error);
            }

            // retry if no error
            final retryOptions = error.requestOptions;
            retryOptions.headers['Authorization'] = 'Bearer ${response.data}';

            try {
              final retryResponse = await dio.fetch(retryOptions);
              return handler.resolve(retryResponse);
            } on DioException catch (err) {
              return handler.next(err);
            }
          }

          return handler.next(error);
        },
      ),
    );

    return dio;
  }

  // Reset
  static void reset() {
    _dio = null;
  }
}

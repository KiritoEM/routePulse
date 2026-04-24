import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:route_pulse_mobile/core/constants/api_constant.dart';
import 'package:route_pulse_mobile/features/auth/data/auth_repository_impl.dart';
import 'package:route_pulse_mobile/shared/services/secure_storage_service.dart';

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
          final token = await SecureStorageService.read('remote_access_token');

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onError: (error, handler) async {
          final isRefreshTokenRequest = error.requestOptions.path.contains(
            ApiConstant.REFRESH_TOKEN_ENDPOINT,
          );

          if (error.response?.statusCode == 401 && !isRefreshTokenRequest) {
            final response = await _authRepository.refreshToken();

            if (response.hasError == true) {
              debugPrint(response.message);
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

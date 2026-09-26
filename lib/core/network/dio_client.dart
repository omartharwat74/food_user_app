import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_endpoints.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/global_error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'interceptors/language_interceptor.dart';

class DioClient {
  DioClient({
    required AuthInterceptor authInterceptor,
    required LoggingInterceptor loggingInterceptor,
    required RetryInterceptor retryInterceptor,
    required GlobalErrorHandlerInterceptor globalErrorHandlerInterceptor,
    required LanguageInterceptor languageInterceptor,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'local': 'ar',
        },
        responseType: ResponseType.json,
      ),
    );
    _dio.interceptors
      ..add(languageInterceptor)
      ..add(authInterceptor);

    if (kDebugMode) {
      _dio.interceptors.add(loggingInterceptor);
    }

    _dio.interceptors
      ..add(retryInterceptor)
      ..add(globalErrorHandlerInterceptor);
  }

  late final Dio _dio;

  Dio get dio => _dio;
}

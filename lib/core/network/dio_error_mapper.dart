import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';

import '../errors/exceptions.dart';

/// Translates a [DioException] into one of the project's custom exceptions
/// so the data layer can map them to typed [Failure]s consistently.
class DioErrorMapper {
  const DioErrorMapper._();

  static Exception map(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const TimeoutException();

      case DioExceptionType.connectionError:
        return const NetworkException();

      case DioExceptionType.cancel:
        return const UnknownException('Request was cancelled');

      case DioExceptionType.badCertificate:
        return const NetworkException('Bad SSL certificate');

      case DioExceptionType.badResponse:
        return _mapBadResponse(error);

      case DioExceptionType.unknown:
        return UnknownException(error.message ?? 'Something went wrong');
    }
  }

  static Exception _mapBadResponse(DioException error) {
    final response = error.response;
    final status = response?.statusCode ?? 0;
    final data = response?.data;
    final message = _extractMessage(data) ?? error.message ?? 'Request failed';

    if (status == 400) {
      return ServerException(message);
    }
    if (status == 401 || status == 403) {
      return UnauthorizedException(message);
    }
    if (status == 422) {
      try {
        debugPrint('[422 ValidationError] ${response?.data}');
      } catch (_) {}
      return ValidationException(
        message,
        errors: _extractValidationErrors(data),
      );
    }
    if (status >= 500) {
      return ServerException(message);
    }
    return ServerException(message);
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map) {
      final msg = data['msg'];
      if (msg is String && msg.trim().isNotEmpty) {
        return msg;
      }
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
      final err = data['error'];
      if (err is String && err.trim().isNotEmpty) {
        return err;
      }
    }
    if (data is String && data.trim().isNotEmpty) {
      return data;
    }
    return null;
  }

  static Map<String, dynamic>? _extractValidationErrors(dynamic data) {
    if (data is Map) {
      if (data['data'] is Map) {
        return Map<String, dynamic>.from(data['data'] as Map);
      }
      if (data['errors'] is Map) {
        return Map<String, dynamic>.from(data['errors'] as Map);
      }
    }
    return null;
  }
}

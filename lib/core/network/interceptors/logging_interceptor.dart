import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Prints long text in chunks (<= 800 chars) to prevent Android/iOS/Dart console truncation.
void printWrapped(String text) {
  if (text.isEmpty) {
    debugPrint('');
    return;
  }
  final pattern = RegExp('.{1,800}', dotAll: true);
  for (final match in pattern.allMatches(text)) {
    debugPrint(match.group(0));
  }
}

/// Debug-only request/response logger.
///
/// Sensitive data is redacted:
///   - `Authorization` header is never printed.
///   - `password` / `newPassword` / `confirmPassword` fields are masked.
class LoggingInterceptor extends Interceptor {
  static const _sensitiveBodyKeys = {
    'password',
    'newPassword',
    'confirmPassword',
    'currentPassword',
    'refreshToken',
    'accessToken',
    'access_token',
    'firebase_id_token',
    'otp',
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      printWrapped('[HTTP →] ${options.method} ${options.uri}');
      final body = _redactBody(options.data);
      if (body != null) {
        printWrapped('[HTTP → body] ${_stringifyBody(body)}');
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      printWrapped(
        '[HTTP ←] ${response.statusCode} ${response.requestOptions.method} '
        '${response.requestOptions.uri}',
      );
      if (response.data != null) {
        printWrapped('[HTTP ← body] ${_stringifyBody(response.data)}');
      }
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      printWrapped(
        '[HTTP ✗] ${err.response?.statusCode ?? '-'} '
        '${err.requestOptions.method} ${err.requestOptions.uri} '
        '| ${err.type} | ${err.message ?? ''}',
      );
      if (err.response?.data != null) {
        printWrapped('[HTTP ✗ body] ${_stringifyBody(err.response!.data)}');
      }
    }
    super.onError(err, handler);
  }

  String _stringifyBody(dynamic data) {
    if (data == null) return '';
    try {
      if (data is Map || data is List) {
        return jsonEncode(data);
      }
    } catch (_) {
      // Fallback if data is not JSON-encodable
    }
    return data.toString();
  }

  Object? _redactBody(dynamic data) {
    if (data is Map) {
      final redacted = <String, dynamic>{};
      data.forEach((key, value) {
        if (_sensitiveBodyKeys.contains(key.toString())) {
          redacted[key.toString()] = '***';
        } else {
          redacted[key.toString()] = _redactBody(value);
        }
      });
      return redacted;
    }
    if (data is List) {
      return data.map((item) => _redactBody(item)).toList();
    }
    return data;
  }
}

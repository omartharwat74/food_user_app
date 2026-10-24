import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/core/network/interceptors/logging_interceptor.dart';

class _CapturingAdapter implements HttpClientAdapter {
  final ResponseBody responseBody;

  _CapturingAdapter({required this.responseBody});

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return responseBody;
  }
}

void main() {
  group('printWrapped', () {
    test('chunks text longer than 800 characters without truncating', () {
      final loggedLines = <String>[];
      final originalDebugPrint = debugPrint;
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null) {
          loggedLines.add(message);
        }
      };

      try {
        final longText = 'A' * 2000;
        printWrapped(longText);

        expect(loggedLines.length, 3);
        expect(loggedLines[0].length, 800);
        expect(loggedLines[1].length, 800);
        expect(loggedLines[2].length, 400);
        expect(loggedLines.join(''), longText);
      } finally {
        debugPrint = originalDebugPrint;
      }
    });

    test('preserves multi-line strings with newlines', () {
      final loggedLines = <String>[];
      final originalDebugPrint = debugPrint;
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null) {
          loggedLines.add(message);
        }
      };

      try {
        final multiLineText = 'line1\nline2\nline3\n${'B' * 900}';
        printWrapped(multiLineText);

        expect(loggedLines.join(''), multiLineText);
      } finally {
        debugPrint = originalDebugPrint;
      }
    });
  });

  group('LoggingInterceptor', () {
    test('logs full response data without artificial 4000-char truncation', () async {
      final loggedLines = <String>[];
      final originalDebugPrint = debugPrint;
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null) {
          loggedLines.add(message);
        }
      };

      try {
        final hugeContent = 'X' * 5000;
        final adapter = _CapturingAdapter(
          responseBody: ResponseBody.fromString(
            '{"data":"$hugeContent"}',
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          ),
        );

        final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
        dio.interceptors.add(LoggingInterceptor());
        dio.httpClientAdapter = adapter;

        await dio.get<dynamic>('/test');

        final fullLog = loggedLines.join('');
        expect(fullLog.contains(hugeContent), isTrue);
        expect(fullLog.contains('[truncated'), isFalse);
      } finally {
        debugPrint = originalDebugPrint;
      }
    });

    test('redacts sensitive fields in request body', () async {
      final loggedLines = <String>[];
      final originalDebugPrint = debugPrint;
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null) {
          loggedLines.add(message);
        }
      };

      try {
        final adapter = _CapturingAdapter(
          responseBody: ResponseBody.fromString('{}', 200),
        );

        final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
        dio.interceptors.add(LoggingInterceptor());
        dio.httpClientAdapter = adapter;

        await dio.post<dynamic>(
          '/login',
          data: {
            'phone': '+201000000000',
            'password': 'secretPassword123',
            'otp': '123456',
          },
        );

        final fullLog = loggedLines.join('');
        expect(fullLog.contains('secretPassword123'), isFalse);
        expect(fullLog.contains('123456'), isFalse);
        expect(fullLog.contains('***'), isTrue);
        expect(fullLog.contains('+201000000000'), isTrue);
      } finally {
        debugPrint = originalDebugPrint;
      }
    });
  });
}

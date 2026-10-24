import 'package:flutter/foundation.dart';

import '../network/interceptors/logging_interceptor.dart';

class AppLogger {
  AppLogger._();

  static void d(String msg) {
    if (kDebugMode) {
      printWrapped('[DEBUG] $msg');
    }
  }

  static void e(String msg, [Object? error]) {
    if (kDebugMode) {
      printWrapped('[ERROR] $msg ${error ?? ''}');
    }
  }
}

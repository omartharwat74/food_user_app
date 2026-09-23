import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageInterceptor extends Interceptor {
  final SharedPreferences prefs;

  LanguageInterceptor(this.prefs);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final saved = prefs.getString('app_locale');
    final String language;
    if (saved == 'ar' || saved == 'en') {
      language = saved!;
    } else {
      final code = ui.PlatformDispatcher.instance.locale.languageCode
          .toLowerCase();
      language = code == 'ar' ? 'ar' : 'en';
    }

    options.headers['local'] = language;
    options.headers['Accept-Language'] = language;
    super.onRequest(options, handler);
  }
}

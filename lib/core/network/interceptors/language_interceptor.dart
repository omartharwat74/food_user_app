import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageInterceptor extends Interceptor {
  final SharedPreferences prefs;

  LanguageInterceptor(this.prefs);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String language = 'ar';

    final saved = prefs.getString('app_locale');
    if (saved == 'ar' || saved == 'en') {
      language = saved!;
    } else if (Intl.defaultLocale != null &&
        (Intl.defaultLocale!.startsWith('ar') ||
            Intl.defaultLocale!.startsWith('en'))) {
      language = Intl.defaultLocale!.startsWith('ar') ? 'ar' : 'en';
    } else {
      try {
        final current = Intl.getCurrentLocale();
        if (current.toLowerCase().startsWith('en')) {
          language = 'en';
        } else {
          language = 'ar';
        }
      } catch (_) {
        language = 'ar';
      }
    }

    // Set standard Accept-Language and backend alias headers
    options.headers['Accept-Language'] = language;
    options.headers['local'] = language;
    options.headers['locale'] = language;

    super.onRequest(options, handler);
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/core/network/interceptors/language_interceptor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('LanguageInterceptor', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      Intl.defaultLocale = null;
    });

    test('sets Accept-Language to ar when saved preference is ar', () async {
      await prefs.setString('app_locale', 'ar');
      final interceptor = LanguageInterceptor(prefs);
      final options = RequestOptions(path: '/test');

      interceptor.onRequest(options, RequestInterceptorHandler());

      expect(options.headers['Accept-Language'], 'ar');
      expect(options.headers['local'], 'ar');
    });

    test('sets Accept-Language to en when saved preference is en', () async {
      await prefs.setString('app_locale', 'en');
      final interceptor = LanguageInterceptor(prefs);
      final options = RequestOptions(path: '/test');

      interceptor.onRequest(options, RequestInterceptorHandler());

      expect(options.headers['Accept-Language'], 'en');
      expect(options.headers['local'], 'en');
    });

    test('sets Accept-Language from Intl.defaultLocale when preference is absent', () async {
      Intl.defaultLocale = 'ar';
      final interceptor = LanguageInterceptor(prefs);
      final options = RequestOptions(path: '/test');

      interceptor.onRequest(options, RequestInterceptorHandler());

      expect(options.headers['Accept-Language'], 'ar');
    });

    test('sets Accept-Language to en when Intl.defaultLocale is en', () async {
      Intl.defaultLocale = 'en';
      final interceptor = LanguageInterceptor(prefs);
      final options = RequestOptions(path: '/test');

      interceptor.onRequest(options, RequestInterceptorHandler());

      expect(options.headers['Accept-Language'], 'en');
    });
  });
}

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_user_app/core/di/injection_container.dart' as di;
import 'package:food_user_app/features/order/presentation/cubit/order_history_cubit.dart';
import 'package:food_user_app/features/order/presentation/cubit/order_history_state.dart';

const _kPrefsLocaleCode = 'app_locale';

/// Persists `ar` / `en` and falls back to the device locale on first launch
/// (Arabic → `ar`, anything else → `en`).
class LocaleController extends ChangeNotifier {
  LocaleController(this._prefs);

  final SharedPreferences _prefs;

  Locale _locale = const Locale('ar');

  Locale get locale => _locale;

  /// Call once at startup after [SharedPreferences] is ready.
  void hydrate() {
    final saved = _prefs.getString(_kPrefsLocaleCode);
    if (saved == 'ar') {
      _locale = const Locale('ar');
    } else if (saved == 'en') {
      _locale = const Locale('en');
    } else {
      _locale = _localeFromPlatform();
      _prefs.setString(_kPrefsLocaleCode, _locale.languageCode);
    }
    Intl.defaultLocale = _locale.languageCode;
    notifyListeners();
  }

  static Locale _localeFromPlatform() {
    final code = ui.PlatformDispatcher.instance.locale.languageCode
        .toLowerCase();
    if (code.startsWith('ar')) {
      return const Locale('ar');
    }
    return const Locale('en');
  }

  Future<void> setLocale(Locale locale) async {
    final code = locale.languageCode;
    if (code != 'ar' && code != 'en') {
      return;
    }
    _locale = Locale(code);
    Intl.defaultLocale = code;
    await _prefs.setString(_kPrefsLocaleCode, code);
    notifyListeners();

    try {
      if (di.sl.isRegistered<OrderHistoryCubit>()) {
        final orderHistoryCubit = di.sl<OrderHistoryCubit>();
        if (orderHistoryCubit.state.status == OrderHistoryStatus.loaded ||
            orderHistoryCubit.state.orders.isNotEmpty) {
          orderHistoryCubit.refreshOrders();
        }
      }
    } catch (_) {}
  }
}

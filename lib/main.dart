import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:food_user_app/app.dart';
import 'package:food_user_app/core/di/injection_container.dart' as di;
import 'package:food_user_app/core/localization/locale_controller.dart';
import 'package:food_user_app/core/theme/theme_controller.dart';
import 'package:food_user_app/features/profile/presentation/controllers/saved_addresses_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await dotenv.load(fileName: '.env');

      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );

        final prefs = await SharedPreferences.getInstance();
        await di.init(prefs: prefs);

        final localeController = LocaleController(prefs);
        localeController.hydrate();

        final themeController = ThemeController(prefs);
        themeController.hydrate();

        // final pushNotificationService = di.sl<PushNotificationService>();
        // await pushNotificationService.initialize();

        final savedAddressesController = SavedAddressesController(
          getSavedAddressesUseCase: di.sl(),
          saveAddressUseCase: di.sl(),
          updateAddressUseCase: di.sl(),
          deleteAddressUseCase: di.sl(),
          setDefaultAddressUseCase: di.sl(),
          prefs: prefs,
        );

        runApp(
          App(
            localeController: localeController,
            themeController: themeController,
            savedAddressesController: savedAddressesController,
          ),
        );
      } catch (e, stackTrace) {
        debugPrint('🔥 CRITICAL INIT ERROR: $e');
        debugPrint('🔥 STACKTRACE: $stackTrace');
      }
    },
    (error, stackTrace) {
      debugPrint('🔥 UNHANDLED ERROR: $error');
    },
  );
}

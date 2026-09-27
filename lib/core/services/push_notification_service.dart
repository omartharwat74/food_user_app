import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../router/app_router.dart';
import '../router/route_names.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Handling a background message: ${message.messageId}');
}

class PushNotificationService {
  PushNotificationService._internal();
  static final PushNotificationService _instance =
      PushNotificationService._internal();
  factory PushNotificationService() => _instance;

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  Dio? _dio;
  bool _isInitialized = false;

  Future<void> init({required Dio dio}) async {
    if (_isInitialized) return;
    _dio = dio;

    final settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
      }
    });

    try {
      final token = await _fcm.getToken();
      if (token != null) {
        await _syncTokenWithServer(token);
      }
    } catch (e) {
      log('Error getting FCM token: $e');
    }

    _fcm.onTokenRefresh.listen((newToken) {
      _syncTokenWithServer(newToken);
    });

    _isInitialized = true;
  }

  void _handleMessage(RemoteMessage message) {
    log('A new onMessageOpenedApp event was published!');
    if (message.data['type'] == 'ORDER_UPDATE') {
      final orderId = message.data['orderId'];
      if (orderId != null) {
        final context =
            AppRouter.router.routerDelegate.navigatorKey.currentContext;
        if (context != null) {
          context.push(RouteNames.orderTrackingFor(orderId.toString()));
        }
      }
    }
  }

  Future<void> _syncTokenWithServer(String token) async {
    if (_dio == null) return;
    try {
      final deviceInfo = DeviceInfoPlugin();
      String deviceId = 'unknown_device_id';
      String platform = 'android';

      if (kIsWeb) {
        platform = 'web';
        final webBrowserInfo = await deviceInfo.webBrowserInfo;
        deviceId = webBrowserInfo.userAgent ?? 'unknown_web_device';
      } else if (Platform.isIOS) {
        platform = 'ios';
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? 'unknown_ios_device';
      } else if (Platform.isAndroid) {
        platform = 'android';
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      }

      final data = {
        'device_id': deviceId,
        'fcm_token': token,
        'platform': platform,
      };

      final response = await _dio!.patch('/api/v1/auth/update-fcm', data: data);

      if (response.statusCode == 200 || response.statusCode == 204) {
        log('FCM token synced successfully');
      } else {
        log('Failed to sync FCM token: ${response.statusCode}');
      }
    } catch (e) {
      log('Error syncing FCM token: $e');
    }
  }
}

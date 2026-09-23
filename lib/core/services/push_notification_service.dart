import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:food_user_app/core/router/app_router.dart';
import 'package:food_user_app/core/router/route_names.dart';
import 'package:go_router/go_router.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission for iOS/Web
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle initial message (if app was terminated)
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Handle background/foreground messages when user taps on notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');
      if (message.notification != null) {
        debugPrint(
          'Message also contained a notification: ${message.notification}',
        );
      }
    });
  }

  void _handleMessage(RemoteMessage message) {
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
}

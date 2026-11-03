import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/features/restaurant/domain/entities/restaurant.dart';
import 'package:food_user_app/features/restaurant/presentation/pages/restaurant_rate_screen.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

void main() {
  Widget buildTestableWidget(Widget child, {Locale locale = const Locale('ar')}) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  group('Restaurant Delivery Price Display Tests', () {
    testWidgets('displays delivery price with currency in Arabic (e.g. 20 ج.م)', (tester) async {
      const restaurant = Restaurant(
        id: '1',
        name: 'عز الشام',
        cuisineType: 'شاورما',
        coverImageUrl: '',
        rating: 4.5,
        deliveryTimeMin: 30,
        deliveryTimeMax: 45,
        deliveryFee: 20.0,
        isFavorited: false,
      );

      await tester.pumpWidget(
        buildTestableWidget(
          const RestaurantRateScreen(restaurant: restaurant),
          locale: const Locale('ar'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('سعر التوصيل'), findsOneWidget);
      expect(find.text('20 ج.م'), findsOneWidget);
    });

    testWidgets('displays Free / مجاني when delivery fee is 0 in Arabic', (tester) async {
      const restaurant = Restaurant(
        id: '1',
        name: 'عز الشام',
        cuisineType: 'شاورما',
        coverImageUrl: '',
        rating: 4.5,
        deliveryTimeMin: 30,
        deliveryTimeMax: 45,
        deliveryFee: 0.0,
        isFavorited: false,
      );

      await tester.pumpWidget(
        buildTestableWidget(
          const RestaurantRateScreen(restaurant: restaurant),
          locale: const Locale('ar'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('سعر التوصيل'), findsOneWidget);
      expect(find.text('مجاني'), findsOneWidget);
    });

    testWidgets('displays delivery price in English (e.g. EGP 20)', (tester) async {
      const restaurant = Restaurant(
        id: '1',
        name: 'Ezz El Sham',
        cuisineType: 'Shawarma',
        coverImageUrl: '',
        rating: 4.5,
        deliveryTimeMin: 30,
        deliveryTimeMax: 45,
        deliveryFee: 20.0,
        isFavorited: false,
      );

      await tester.pumpWidget(
        buildTestableWidget(
          const RestaurantRateScreen(restaurant: restaurant),
          locale: const Locale('en'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Delivery price'), findsOneWidget);
      expect(find.text('EGP 20'), findsOneWidget);
    });
  });
}

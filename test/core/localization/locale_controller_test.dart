import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/core/di/injection_container.dart' as di;
import 'package:food_user_app/core/localization/locale_controller.dart';
import 'package:food_user_app/features/order/domain/entities/order.dart';
import 'package:food_user_app/features/order/domain/entities/orders_paginated_data.dart';
import 'package:food_user_app/features/order/domain/usecases/get_order_history_usecase.dart';
import 'package:food_user_app/features/order/presentation/cubit/order_history_cubit.dart';
import 'package:food_user_app/features/order/presentation/cubit/order_history_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockGetOrderHistoryUseCase extends Mock implements GetOrderHistoryUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  late MockGetOrderHistoryUseCase mockGetOrderHistoryUseCase;
  late OrderHistoryCubit orderHistoryCubit;

  setUpAll(() {
    registerFallbackValue(const GetOrderHistoryParams());
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({'app_locale': 'ar'});
    prefs = await SharedPreferences.getInstance();

    mockGetOrderHistoryUseCase = MockGetOrderHistoryUseCase();
    orderHistoryCubit = OrderHistoryCubit(mockGetOrderHistoryUseCase);

    if (di.sl.isRegistered<OrderHistoryCubit>()) {
      di.sl.unregister<OrderHistoryCubit>();
    }
    di.sl.registerSingleton<OrderHistoryCubit>(orderHistoryCubit);
  });

  tearDown(() {
    if (di.sl.isRegistered<OrderHistoryCubit>()) {
      di.sl.unregister<OrderHistoryCubit>();
    }
    orderHistoryCubit.close();
  });

  group('LocaleController Language Change & Orders Reload Tests', () {
    test('setLocale persists new locale and reloads orders if cubit has loaded orders', () async {
      const order = Order(
        id: 1,
        code: 'ORD-1',
        status: 'delivered',
        paymentMethod: 'cash',
        selfPickup: false,
        summary: OrderSummary(),
        items: [],
      );

      // Pre-load orders in Arabic
      when(() => mockGetOrderHistoryUseCase(any())).thenAnswer(
        (_) async => const Right(OrdersPaginatedData(
          items: [order],
          currentPage: 1,
          lastPage: 1,
          perPage: 10,
          total: 1,
        )),
      );

      await orderHistoryCubit.loadOrders();
      expect(orderHistoryCubit.state.status, OrderHistoryStatus.loaded);
      expect(orderHistoryCubit.state.orders.length, 1);

      // Setup controller and change language to English
      final controller = LocaleController(prefs);
      controller.hydrate();
      expect(controller.locale.languageCode, 'ar');

      var notified = false;
      controller.addListener(() => notified = true);

      await controller.setLocale(const Locale('en'));

      expect(controller.locale.languageCode, 'en');
      expect(prefs.getString('app_locale'), 'en');
      expect(notified, isTrue);

      // Verify refreshOrders was called and made another request
      verify(() => mockGetOrderHistoryUseCase(any())).called(2);
    });

    test('refreshOrders does not execute concurrently when already refreshing', () async {
      when(() => mockGetOrderHistoryUseCase(any())).thenAnswer(
        (_) async {
          await Future.delayed(const Duration(milliseconds: 50));
          return const Right(OrdersPaginatedData(
            items: [],
            currentPage: 1,
            lastPage: 1,
            perPage: 10,
            total: 0,
          ));
        },
      );

      // Trigger two refresh calls in parallel
      final future1 = orderHistoryCubit.refreshOrders();
      final future2 = orderHistoryCubit.refreshOrders();

      await Future.wait([future1, future2]);

      // Only 1 network call should have occurred
      verify(() => mockGetOrderHistoryUseCase(any())).called(1);
    });
  });
}

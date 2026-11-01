import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/features/cart/domain/entities/cart.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:food_user_app/features/checkout/presentation/pages/checkout_screen.dart';
import 'package:food_user_app/features/payment/presentation/cubit/checkout_cubit.dart';
import 'package:food_user_app/features/payment/presentation/cubit/checkout_state.dart';
import 'package:food_user_app/features/profile/presentation/controllers/saved_addresses_controller.dart';
import 'package:food_user_app/features/profile/presentation/controllers/saved_addresses_scope.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckoutCubit extends MockCubit<CheckoutState>
    implements CheckoutCubit {}

class MockCartCubit extends MockCubit<CartState> implements CartCubit {}

class MockSavedAddressesController extends Mock
    implements SavedAddressesController {}

void main() {
  late MockCheckoutCubit mockCheckoutCubit;
  late MockCartCubit mockCartCubit;
  late MockSavedAddressesController mockAddressesController;

  const sampleCart = Cart(
    id: 'cart-1',
    restaurantId: 'rest-1',
    restaurantName: 'عز الشام',
    restaurantAddress: 'مدينتي، القاهرة الجديدة',
    items: [],
    subtotal: 100.0,
    deliveryFee: 20.0,
    tax: 14.0,
    discount: 0.0,
    total: 134.0,
  );

  setUp(() {
    mockCheckoutCubit = MockCheckoutCubit();
    mockCartCubit = MockCartCubit();
    mockAddressesController = MockSavedAddressesController();

    when(() => mockCheckoutCubit.state).thenReturn(
      const CheckoutState.initial(),
    );
    when(() => mockCartCubit.state).thenReturn(
      const CartState.loaded(cart: sampleCart),
    );
    when(() => mockAddressesController.hasLoaded).thenReturn(true);
    when(() => mockAddressesController.isLoading).thenReturn(false);
    when(() => mockAddressesController.addresses).thenReturn([]);
    when(() => mockAddressesController.selectedAddress).thenReturn(null);
  });

  Widget buildTestableWidget(Widget child, {Locale locale = const Locale('ar')}) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: SavedAddressesScope(
        notifier: mockAddressesController,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<CheckoutCubit>.value(value: mockCheckoutCubit),
            BlocProvider<CartCubit>.value(value: mockCartCubit),
          ],
          child: child,
        ),
      ),
    );
  }

  group('CheckoutScreen Self-Pickup Tests', () {
    testWidgets('shows self-pickup banner and branch address when isSelfPickup is true', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const CheckoutScreen(isSelfPickup: true),
          locale: const Locale('ar'),
        ),
      );
      await tester.pump();

      // Verify self-pickup banner text
      expect(
        find.byWidgetPredicate((w) =>
            w is RichText &&
            w.text.toPlainText().contains('اطلب واستلم') &&
            w.text.toPlainText().contains('بنفسك')),
        findsOneWidget,
      );
      expect(
        find.text('اطلب منتجاتك أونلاين واستلمها مباشرة من الفرع، بدون الحاجة لخدمة التوصيل.'),
        findsOneWidget,
      );

      // Verify branch address header and address
      expect(find.text('عنوان الفرع :'), findsOneWidget);
      expect(find.text('مدينتي، القاهرة الجديدة'), findsOneWidget);

      // Delivery address card should NOT be shown
      expect(find.text('تغيير العنوان'), findsNothing);
    });

    testWidgets('translates self-pickup banner and branch address in English', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const CheckoutScreen(isSelfPickup: true),
          locale: const Locale('en'),
        ),
      );
      await tester.pump();

      // Verify English texts
      expect(
        find.byWidgetPredicate((w) =>
            w is RichText &&
            w.text.toPlainText().contains('Order & Pick up') &&
            w.text.toPlainText().contains('Yourself')),
        findsOneWidget,
      );
      expect(find.text('Branch address :'), findsOneWidget);
    });

    testWidgets('shows delivery address and hides pickup banner when isSelfPickup is false', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const CheckoutScreen(isSelfPickup: false),
        ),
      );
      await tester.pump();

      // Delivery address card should be present
      expect(find.text('تغيير العنوان'), findsOneWidget);

      // Self-pickup banner and branch address should NOT be present
      expect(
        find.byWidgetPredicate(
            (w) => w is RichText && w.text.toPlainText().contains('بنفسك')),
        findsNothing,
      );
      expect(find.text('عنوان الفرع :'), findsNothing);
    });

    testWidgets('submits checkout with selfPickup: true without requiring delivery address', (tester) async {
      when(() => mockCheckoutCubit.checkout(
            paymentMethod: any(named: 'paymentMethod'),
            addressId: any(named: 'addressId'),
            selfPickup: true,
            couponCode: any(named: 'couponCode'),
            note: any(named: 'note'),
          )).thenAnswer((_) async {});

      await tester.pumpWidget(
        buildTestableWidget(
          const CheckoutScreen(isSelfPickup: true),
        ),
      );
      await tester.pump();

      // Tap on confirm order button ('تنفيذ الطلب')
      await tester.tap(find.text('تنفيذ الطلب'));
      await tester.pump();

      // Verify checkout called with selfPickup: true and addressId: null
      verify(() => mockCheckoutCubit.checkout(
            paymentMethod: any(named: 'paymentMethod'),
            addressId: null,
            selfPickup: true,
            couponCode: any(named: 'couponCode'),
            note: any(named: 'note'),
          )).called(1);
    });
  });
}

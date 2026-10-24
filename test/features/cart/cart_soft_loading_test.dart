import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/services/snackbar_service.dart';
import 'package:food_user_app/core/usecases/usecase.dart';
import 'package:food_user_app/features/cart/domain/entities/cart.dart';
import 'package:food_user_app/features/cart/domain/entities/cart_item.dart';
import 'package:food_user_app/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/update_cart_item_usecase.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:food_user_app/features/cart/presentation/widgets/cart_item_tile.dart';
import 'package:food_user_app/features/cart/presentation/widgets/cart_summary.dart';
import 'package:food_user_app/features/checkout/domain/usecases/apply_promo_usecase.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetCartUseCase extends Mock implements GetCartUseCase {}

class _MockAddToCartUseCase extends Mock implements AddToCartUseCase {}

class _MockUpdateCartItemUseCase extends Mock
    implements UpdateCartItemUseCase {}

class _MockRemoveFromCartUseCase extends Mock
    implements RemoveFromCartUseCase {}

class _MockClearCartUseCase extends Mock implements ClearCartUseCase {}

class _MockApplyPromoUseCase extends Mock implements ApplyPromoUseCase {}

class _MockSnackbarService extends Mock implements SnackbarService {}

void main() {
  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(
      const UpdateCartItemParams(itemId: '1', quantity: 1),
    );
  });

  const testItem = CartItem(
    id: '101',
    menuItemId: '55',
    name: 'Burger',
    price: 100.0,
    quantity: 2,
  );

  const initialCart = Cart(
    id: '1',
    items: [testItem],
    subtotal: 200.0,
    deliveryFee: 20.0,
    tax: 10.0,
    discount: 0.0,
    total: 230.0,
  );

  group('CartCubit Targeted Soft Loading', () {
    late _MockGetCartUseCase mockGetCartUseCase;
    late _MockAddToCartUseCase mockAddToCartUseCase;
    late _MockUpdateCartItemUseCase mockUpdateCartItemUseCase;
    late _MockRemoveFromCartUseCase mockRemoveFromCartUseCase;
    late _MockClearCartUseCase mockClearCartUseCase;
    late _MockApplyPromoUseCase mockApplyPromoUseCase;
    late _MockSnackbarService mockSnackbarService;
    late CartCubit cartCubit;

    setUp(() {
      mockGetCartUseCase = _MockGetCartUseCase();
      mockAddToCartUseCase = _MockAddToCartUseCase();
      mockUpdateCartItemUseCase = _MockUpdateCartItemUseCase();
      mockRemoveFromCartUseCase = _MockRemoveFromCartUseCase();
      mockClearCartUseCase = _MockClearCartUseCase();
      mockApplyPromoUseCase = _MockApplyPromoUseCase();
      mockSnackbarService = _MockSnackbarService();

      cartCubit = CartCubit(
        getCartUseCase: mockGetCartUseCase,
        addToCartUseCase: mockAddToCartUseCase,
        updateCartItemUseCase: mockUpdateCartItemUseCase,
        removeFromCartUseCase: mockRemoveFromCartUseCase,
        clearCartUseCase: mockClearCartUseCase,
        applyPromoUseCase: mockApplyPromoUseCase,
        snackbarService: mockSnackbarService,
      );
    });

    tearDown(() {
      cartCubit.close();
    });

    test('updateItemQuantity emits loaded with updatingProductId and never emits CartLoading', () async {
      when(
        () => mockGetCartUseCase(any()),
      ).thenAnswer((_) async => const Right(initialCart));

      await cartCubit.loadCart();
      expect(cartCubit.state, const CartState.loaded(cart: initialCart));

      const updatedCart = Cart(
        id: '1',
        items: [
          CartItem(
            id: '101',
            menuItemId: '55',
            name: 'Burger',
            price: 100.0,
            quantity: 3,
          ),
        ],
        subtotal: 300.0,
        deliveryFee: 20.0,
        tax: 15.0,
        discount: 0.0,
        total: 335.0,
      );

      when(
        () => mockUpdateCartItemUseCase(any()),
      ).thenAnswer((_) async => const Right(updatedCart));

      final emittedStates = <CartState>[];
      final subscription = cartCubit.stream.listen(emittedStates.add);

      await cartCubit.updateItemQuantity('101', 3);
      await pumpEventQueue();

      expect(emittedStates.length, 2);
      // State 1: Soft loading with updatingProductId = 55
      expect(
        emittedStates[0],
        const CartState.loaded(
          cart: initialCart,
          updatingProductId: 55,
        ),
      );
      // State 2: Success with updatingProductId = null
      expect(
        emittedStates[1],
        const CartState.loaded(
          cart: updatedCart,
          updatingProductId: null,
        ),
      );

      await subscription.cancel();
    });

    test('updateItemQuantity on failure shows TopError and reverts updatingProductId to null', () async {
      when(
        () => mockGetCartUseCase(any()),
      ).thenAnswer((_) async => const Right(initialCart));

      await cartCubit.loadCart();

      when(
        () => mockUpdateCartItemUseCase(any()),
      ).thenAnswer((_) async => const Left(ServerFailure('Out of stock')));

      final emittedStates = <CartState>[];
      final subscription = cartCubit.stream.listen(emittedStates.add);

      await cartCubit.updateItemQuantity('101', 3);
      await pumpEventQueue();

      verify(() => mockSnackbarService.showTopError('Out of stock')).called(1);

      expect(emittedStates.length, 2);
      // State 1: Soft loading
      expect(
        emittedStates[0],
        const CartState.loaded(
          cart: initialCart,
          updatingProductId: 55,
        ),
      );
      // State 2: Failure recovery (keeps initialCart, resets updatingProductId to null)
      expect(
        emittedStates[1],
        const CartState.loaded(
          cart: initialCart,
          updatingProductId: null,
        ),
      );

      await subscription.cancel();
    });
  });

  group('CartItemTile UI', () {
    Widget buildTestWidget({
      required CartState state,
      required CartItem item,
    }) {
      final mockGet = _MockGetCartUseCase();
      final mockAdd = _MockAddToCartUseCase();
      final mockUpd = _MockUpdateCartItemUseCase();
      final mockRem = _MockRemoveFromCartUseCase();
      final mockClr = _MockClearCartUseCase();
      final mockPrm = _MockApplyPromoUseCase();
      final mockSnk = _MockSnackbarService();

      final cubit = CartCubit(
        getCartUseCase: mockGet,
        addToCartUseCase: mockAdd,
        updateCartItemUseCase: mockUpd,
        removeFromCartUseCase: mockRem,
        clearCartUseCase: mockClr,
        applyPromoUseCase: mockPrm,
        snackbarService: mockSnk,
      );

      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ar'),
        home: Scaffold(
          body: BlocProvider<CartCubit>.value(
            value: cubit,
            child: CartItemTile(
              item: item,
              isUpdating: state.updatingProductId == item.productId,
              onEdit: () {},
              onIncrement: () {},
              onDecrement: () {},
            ),
          ),
        ),
      );
    }

    testWidgets('shows CircularProgressIndicator when updatingProductId matches item', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          state: const CartState.loaded(
            cart: initialCart,
            updatingProductId: 55,
          ),
          item: testItem,
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows normal controls when not updating', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          state: const CartState.loaded(
            cart: initialCart,
            updatingProductId: null,
          ),
          item: testItem,
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('2'), findsOneWidget);
    });
  });

  group('CartSummary UI', () {
    testWidgets('disables checkout button and shows CircularProgressIndicator when isUpdating is true', (tester) async {
      var checkoutTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ar'),
          home: Scaffold(
            body: SingleChildScrollView(
              child: CartSummary(
                subtotal: 100,
                delivery: 10,
                tax: 5,
                discount: 0,
                total: 115,
                isUpdating: true,
                onCheckout: () => checkoutTapped = true,
                onAddMore: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.tap(find.byType(CircularProgressIndicator));
      await tester.pump();
      expect(checkoutTapped, isFalse);
    });

    testWidgets('enables checkout button when isUpdating is false', (tester) async {
      var checkoutTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ar'),
          home: Scaffold(
            body: SingleChildScrollView(
              child: CartSummary(
                subtotal: 100,
                delivery: 10,
                tax: 5,
                discount: 0,
                total: 115,
                isUpdating: false,
                onCheckout: () => checkoutTapped = true,
                onAddMore: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.tap(find.text('تابع الدفع'));
      await tester.pump();
      expect(checkoutTapped, isTrue);
    });
  });
}

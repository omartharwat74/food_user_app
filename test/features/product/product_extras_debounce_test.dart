import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/core/services/snackbar_service.dart';
import 'package:food_user_app/core/usecases/usecase.dart';
import 'package:food_user_app/features/cart/domain/entities/cart.dart';
import 'package:food_user_app/features/cart/domain/entities/cart_extra_item.dart';
import 'package:food_user_app/features/cart/domain/entities/cart_item.dart';
import 'package:food_user_app/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/get_cart_extras_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/update_cart_item_usecase.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_extras_cubit.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_extras_state.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:food_user_app/features/checkout/domain/usecases/apply_promo_usecase.dart';
import 'package:food_user_app/features/product/presentation/widgets/product_extras_section.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetCartUseCase extends Mock implements GetCartUseCase {}
class _MockAddToCartUseCase extends Mock implements AddToCartUseCase {}
class _MockUpdateCartItemUseCase extends Mock implements UpdateCartItemUseCase {}
class _MockRemoveFromCartUseCase extends Mock implements RemoveFromCartUseCase {}
class _MockClearCartUseCase extends Mock implements ClearCartUseCase {}
class _MockApplyPromoUseCase extends Mock implements ApplyPromoUseCase {}
class _MockSnackbarService extends Mock implements SnackbarService {}
class _MockGetCartExtrasUseCase extends Mock implements GetCartExtrasUseCase {}

void main() {
  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(
      const AddToCartParams(productId: '1', quantity: 1, optionValueIds: []),
    );
    registerFallbackValue(
      const UpdateCartItemParams(itemId: '1', quantity: 1),
    );
  });

  late _MockGetCartUseCase mockGetCart;
  late _MockAddToCartUseCase mockAddToCart;
  late _MockUpdateCartItemUseCase mockUpdateCartItem;
  late _MockRemoveFromCartUseCase mockRemoveFromCart;
  late _MockClearCartUseCase mockClearCart;
  late _MockApplyPromoUseCase mockApplyPromo;
  late _MockSnackbarService mockSnackbar;
  late _MockGetCartExtrasUseCase mockGetCartExtras;

  late CartCubit cartCubit;
  late CartExtrasCubit cartExtrasCubit;

  const extraItem = CartExtraItem(
    id: 10,
    name: 'كولا كانز',
    basePrice: 20.0,
    priceAfterDiscount: 20.0,
  );

  setUp(() {
    mockGetCart = _MockGetCartUseCase();
    mockAddToCart = _MockAddToCartUseCase();
    mockUpdateCartItem = _MockUpdateCartItemUseCase();
    mockRemoveFromCart = _MockRemoveFromCartUseCase();
    mockClearCart = _MockClearCartUseCase();
    mockApplyPromo = _MockApplyPromoUseCase();
    mockSnackbar = _MockSnackbarService();
    mockGetCartExtras = _MockGetCartExtrasUseCase();

    cartCubit = CartCubit(
      getCartUseCase: mockGetCart,
      addToCartUseCase: mockAddToCart,
      updateCartItemUseCase: mockUpdateCartItem,
      removeFromCartUseCase: mockRemoveFromCart,
      clearCartUseCase: mockClearCart,
      applyPromoUseCase: mockApplyPromo,
      snackbarService: mockSnackbar,
    );

    cartExtrasCubit = CartExtrasCubit(
      getCartExtrasUseCase: mockGetCartExtras,
      addToCartUseCase: mockAddToCart,
    );
  });

  tearDown(() {
    cartCubit.close();
    cartExtrasCubit.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ar'),
      home: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider<CartCubit>.value(value: cartCubit),
            BlocProvider<CartExtrasCubit>.value(value: cartExtrasCubit),
          ],
          child: const ProductExtrasSection(),
        ),
      ),
    );
  }

  testWidgets('shows counter optimistically on + tap and fires debounced addItem after 500ms', (tester) async {
    when(() => mockAddToCart(any())).thenAnswer(
      (_) async => const Right(Cart(
        id: '1',
        items: [
          CartItem(id: 'c1', menuItemId: '10', name: 'كولا كانز', price: 20.0, quantity: 2),
        ],
        subtotal: 40.0,
        deliveryFee: 15.0,
        tax: 0.0,
        discount: 0.0,
        total: 55.0,
      )),
    );

    // Initial cart loaded with empty items
    cartCubit.emit(const CartState.loaded(cart: Cart.empty()));
    cartExtrasCubit.emit(const CartExtrasState(items: [extraItem]));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('كولا كانز'), findsOneWidget);
    // Initially not in cart, shows + button (not the quantity number)
    expect(find.text('1'), findsNothing);

    // Tap + for the first time
    final addButton = find.byKey(const ValueKey('extra_add_10'));
    await tester.tap(addButton);
    await tester.pump();

    // Optimistically shows quantity 1 immediately!
    expect(find.text('1'), findsOneWidget);

    // Tap + again before 500ms
    await tester.pump(const Duration(milliseconds: 200));
    final incrementFinder = find.byKey(const ValueKey('extra_increment_10'));
    await tester.tap(incrementFinder);
    await tester.pump();

    // Optimistically shows quantity 2!
    expect(find.text('2'), findsOneWidget);
    // No network call yet because of debounce
    verifyNever(() => mockAddToCart(any()));

    // Fast-forward past 500ms
    await tester.pump(const Duration(milliseconds: 600));

    // Now AddToCart is called with quantity 2!
    verify(() => mockAddToCart(const AddToCartParams(
      productId: '10',
      quantity: 2,
      optionValueIds: [],
    ))).called(1);
  });

  testWidgets('decrements quantity optimistically and debounces updateItemQuantity', (tester) async {
    when(() => mockUpdateCartItem(any())).thenAnswer(
      (_) async => const Right(Cart(
        id: '1',
        items: [
          CartItem(id: 'c1', menuItemId: '10', name: 'كولا كانز', price: 20.0, quantity: 2),
        ],
        subtotal: 40.0,
        deliveryFee: 15.0,
        tax: 0.0,
        discount: 0.0,
        total: 55.0,
      )),
    );

    // Cart contains item with quantity 3
    cartCubit.emit(const CartState.loaded(
      cart: Cart(
        id: '1',
        items: [
          CartItem(id: 'c1', menuItemId: '10', name: 'كولا كانز', price: 20.0, quantity: 3),
        ],
        subtotal: 60.0,
        deliveryFee: 15.0,
        tax: 0.0,
        discount: 0.0,
        total: 75.0,
      ),
    ));
    cartExtrasCubit.emit(const CartExtrasState(items: [extraItem]));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('3'), findsOneWidget);

    // Tap decrement
    final decrementFinder = find.byKey(const ValueKey('extra_decrement_10'));
    await tester.tap(decrementFinder);
    await tester.pump();

    // Optimistically shows 2
    expect(find.text('2'), findsOneWidget);
    verifyNever(() => mockUpdateCartItem(any()));

    // Elapse 500ms
    await tester.pump(const Duration(milliseconds: 600));

    // Calls updateCartItem with new quantity 2
    verify(() => mockUpdateCartItem(const UpdateCartItemParams(
      itemId: 'c1',
      quantity: 2,
    ))).called(1);
  });
}

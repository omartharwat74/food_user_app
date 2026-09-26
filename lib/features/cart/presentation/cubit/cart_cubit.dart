import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/cart/domain/entities/cart.dart';

import 'package:food_user_app/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/update_cart_item_usecase.dart';
import 'package:food_user_app/features/checkout/domain/usecases/apply_promo_usecase.dart';
import 'package:food_user_app/core/usecases/usecase.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final UpdateCartItemUseCase updateCartItemUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final ClearCartUseCase clearCartUseCase;
  final ApplyPromoUseCase applyPromoUseCase;

  CartCubit({
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.updateCartItemUseCase,
    required this.removeFromCartUseCase,
    required this.clearCartUseCase,
    required this.applyPromoUseCase,
  }) : super(const CartState.initial());

  Future<void> loadCart() async {
    emit(const CartState.loading());
    final result = await getCartUseCase(NoParams());
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        CartState.error(cart: const Cart.empty(), message: failure.message),
      ),
      (cart) => emit(CartState.loaded(cart: cart)),
    );
  }

  Future<void> addItem({
    required String productId,
    required int quantity,
    required List<int> optionValueIds,
  }) async {
    final currentCart = state.maybeWhen(
      loaded: (cart, promo) => cart,
      error: (cart, promo, message) => cart,
      orElse: () => const Cart.empty(),
    );
    final currentPromo = state.maybeWhen(
      loaded: (cart, promo) => promo,
      error: (cart, promo, message) => promo,
      orElse: () => null,
    );

    emit(const CartState.loading());

    final result = await addToCartUseCase(
      AddToCartParams(
        productId: productId,
        quantity: quantity,
        optionValueIds: optionValueIds,
      ),
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        final msg = failure.message.toLowerCase();
        if (msg.contains('cart_store_conflict') ||
            msg.contains('السلة تحتوي منتجات من متجر آخر') ||
            msg.contains('another store') ||
            msg.contains('different store') ||
            msg.contains('من متجر آخر')) {
          emit(
            CartState.conflict(
              cart: currentCart,
              newRestaurantId: '',
              menuItemId: productId,
              name: '',
              price: 0,
              quantity: quantity,
              selectedModifiers: optionValueIds
                  .map((id) => {'option_id': id.toString()})
                  .toList(),
              notes: null,
            ),
          );
          return;
        }

        emit(
          CartState.error(
            cart: currentCart,
            appliedPromo: currentPromo,
            message: failure.message,
          ),
        );
      },
      (serverCart) =>
          emit(CartState.loaded(cart: serverCart, appliedPromo: currentPromo)),
    );
  }

  Future<void> clearAndAddToCart({
    required String restaurantId,
    required String menuItemId,
    required String name,
    required int price,
    required int quantity,
    List<Map<String, dynamic>>? selectedModifiers,
    String? notes,
  }) async {
    final currentCart = state.maybeWhen(
      loaded: (cart, promo) => cart,
      error: (cart, promo, message) => cart,
      orElse: () => const Cart.empty(),
    );
    final currentPromo = state.maybeWhen(
      loaded: (cart, promo) => promo,
      error: (cart, promo, message) => promo,
      orElse: () => null,
    );

    emit(const CartState.loading());
    final clearResult = await clearCartUseCase(NoParams());
    if (isClosed) return;

    await clearResult.fold(
      (failure) async {
        if (isClosed) return;
        emit(
          CartState.error(
            cart: currentCart,
            appliedPromo: currentPromo,
            message: failure.message,
          ),
        );
      },
      (_) async {
        if (isClosed) return;
        emit(const CartState.loaded(cart: Cart.empty(), appliedPromo: null));
        // Extract optionValueIds from selectedModifiers
        final List<int> optionValueIds = [];
        if (selectedModifiers != null) {
          for (final mod in selectedModifiers) {
            final optionId = mod['option_id'];
            if (optionId != null) {
              final parsed = int.tryParse(optionId.toString());
              if (parsed != null) optionValueIds.add(parsed);
            }
          }
        }
        await addItem(
          productId: menuItemId,
          quantity: quantity,
          optionValueIds: optionValueIds,
        );
      },
    );
  }

  Future<void> updateItemQuantity(String itemId, int newQuantity) async {
    final currentCart = state.maybeWhen(
      loaded: (cart, promo) => cart,
      error: (cart, promo, message) => cart,
      orElse: () => const Cart.empty(),
    );
    final currentPromo = state.maybeWhen(
      loaded: (cart, promo) => promo,
      error: (cart, promo, message) => promo,
      orElse: () => null,
    );

    emit(const CartState.loading());

    final result = newQuantity <= 0
        ? await removeFromCartUseCase(itemId)
        : await updateCartItemUseCase(
            UpdateCartItemParams(itemId: itemId, quantity: newQuantity),
          );

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        CartState.error(
          cart: currentCart,
          appliedPromo: currentPromo,
          message: failure.message,
        ),
      ),
      (serverCart) =>
          emit(CartState.loaded(cart: serverCart, appliedPromo: currentPromo)),
    );
  }

  Future<void> removeItem(String itemId) async {
    await updateItemQuantity(itemId, 0);
  }

  Future<void> clearCart() async {
    final currentCart = state.maybeWhen(
      loaded: (cart, promo) => cart,
      error: (cart, promo, message) => cart,
      orElse: () => const Cart.empty(),
    );
    final currentPromo = state.maybeWhen(
      loaded: (cart, promo) => promo,
      error: (cart, promo, message) => promo,
      orElse: () => null,
    );

    emit(const CartState.loading());

    final result = await clearCartUseCase(NoParams());
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        CartState.error(
          cart: currentCart,
          appliedPromo: currentPromo,
          message: failure.message,
        ),
      ),
      (_) =>
          emit(const CartState.loaded(cart: Cart.empty(), appliedPromo: null)),
    );
  }

  Future<void> applyPromoCode(String code) async {
    final currentCart = state.maybeWhen(
      loaded: (cart, promo) => cart,
      error: (cart, promo, message) => cart,
      orElse: () => const Cart.empty(),
    );
    final currentPromo = state.maybeWhen(
      loaded: (cart, promo) => promo,
      error: (cart, promo, message) => promo,
      orElse: () => null,
    );

    if (currentCart.id.isEmpty) return;

    emit(const CartState.loading());

    final result = await applyPromoUseCase(
      ApplyPromoParams(code: code, subtotal: currentCart.subtotal),
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        CartState.error(
          cart: currentCart,
          appliedPromo: currentPromo,
          message: failure.message,
        ),
      ),
      (promo) {
        final updatedCart = Cart(
          id: currentCart.id,
          restaurantId: currentCart.restaurantId,
          restaurantName: currentCart.restaurantName,
          items: currentCart.items,
          subtotal: currentCart.subtotal,
          deliveryFee: currentCart.deliveryFee,
          tax: currentCart.tax,
          discount: promo.discountAmount,
          total: promo.total,
        );
        emit(CartState.loaded(cart: updatedCart, appliedPromo: promo));
      },
    );
  }
}

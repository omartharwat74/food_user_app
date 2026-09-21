import re

with open('lib/features/cart/presentation/cubit/cart_cubit.dart', 'r') as f:
    content = f.read()

# Replace the whole body of addItem (from `final currentCart` to just before `final result = await addToCartUseCase`)
old_body_regex = r'    final currentCart = state\.maybeWhen\([\s\S]*?emit\(CartState\.loaded\(cart: optimisticCart, appliedPromo: currentPromo\)\);'
new_body = """    final currentCart = state.maybeWhen(
      loaded: (cart, promo) => cart,
      error: (cart, promo, message) => cart,
      orElse: () => const Cart.empty(),
    );
    final currentPromo = state.maybeWhen(
      loaded: (cart, promo) => promo,
      error: (cart, promo, message) => promo,
      orElse: () => null,
    );

    emit(const CartState.loading());"""

content = re.sub(old_body_regex, new_body, content)

# Also wait, I see `final result = await addToCartUseCase` but the parameter was `AddToCartParams(productId: productId, ...)`
# Wait, let's make sure that's correct.

with open('lib/features/cart/presentation/cubit/cart_cubit.dart', 'w') as f:
    f.write(content)


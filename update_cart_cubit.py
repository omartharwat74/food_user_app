import re

with open('lib/features/cart/presentation/cubit/cart_cubit.dart', 'r') as f:
    content = f.read()

# Replace addToCart signature
new_signature = """  Future<void> addItem({
    required String productId,
    required int quantity,
    required List<int> optionValueIds,
  }) async {"""

content = re.sub(r'  Future<void> addToCart\(\{.*?\}\) async \{', new_signature, content, flags=re.DOTALL)

# Update the call to addToCartUseCase
# The old call is:
#    final result = await addToCartUseCase(
#      AddToCartParams(
#        menuItemId: menuItemId,
#        quantity: quantity,
#        selectedModifiers: selectedModifiers,
#        notes: notes,
#      ),
#    );
# We need to change it to call addItemUseCase? Or just modify AddToCartUseCase.
# Let's change the use case call to:
new_call = """    final result = await addToCartUseCase(
      AddToCartParams(
        productId: productId,
        quantity: quantity,
        optionValueIds: optionValueIds,
      ),
    );"""
content = re.sub(r'    final result = await addToCartUseCase\([\s\S]*?,\n    \);', new_call, content)

# Remove the conflict check block since we are not taking restaurantId anymore?
# Wait! The conflict check needs `restaurantId`. If we don't take it, we can't do local conflict check.
# Let's just remove the conflict check block completely! The API will handle it.
conflict_check = r'    if \(currentCart\.items\.isNotEmpty.*?\n    \}\n\n'
content = re.sub(conflict_check, '', content, flags=re.DOTALL)

with open('lib/features/cart/presentation/cubit/cart_cubit.dart', 'w') as f:
    f.write(content)


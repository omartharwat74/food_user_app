import re

with open('lib/features/cart/presentation/cubit/cart_cubit.dart', 'r') as f:
    content = f.read()

# Replace the inner call inside clearAndAddToCart
old_inner_call = r"""        await addToCart\(
          restaurantId: restaurantId,
          menuItemId: menuItemId,
          name: name,
          price: price,
          quantity: quantity,
          selectedModifiers: selectedModifiers,
          notes: notes,
        \);"""

new_inner_call = """        // Extract optionValueIds from selectedModifiers
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
        );"""

content = re.sub(old_inner_call, new_inner_call, content)

with open('lib/features/cart/presentation/cubit/cart_cubit.dart', 'w') as f:
    f.write(content)


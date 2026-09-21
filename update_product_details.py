import re

with open('lib/features/product/presentation/pages/product_details_screen.dart', 'r') as f:
    content = f.read()

# Replace // TODO: Add to cart with actual call
add_to_cart_code = """              final List<Map<String, dynamic>> modifiers = [];
              _selectedOptions.forEach((modId, selectedIds) {
                for (final optId in selectedIds) {
                  modifiers.add({
                    'modifier_id': modId,
                    'option_id': optId,
                  });
                }
              });

              context.read<CartCubit>().addToCart(
                restaurantId: '',
                menuItemId: product.id,
                name: product.name,
                price: unitPrice,
                quantity: _quantity,
                selectedModifiers: modifiers,
                notes: _notes,
              );
              // NOT popping context here! The BlocListener in parent screen handles it.
"""
content = content.replace('// TODO: Add to cart\n              context.pop();', add_to_cart_code)

with open('lib/features/product/presentation/pages/product_details_screen.dart', 'w') as f:
    f.write(content)


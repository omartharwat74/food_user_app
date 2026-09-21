import re

with open('lib/features/product/presentation/pages/product_details_screen.dart', 'r') as f:
    content = f.read()

# Replace the addToCart call with addItem
old_code = r"""              final List<Map<String, dynamic>> modifiers = \[\];
              _selectedOptions\.forEach\(\(modId, selectedIds\) \{
                for \(final optId in selectedIds\) \{
                  modifiers\.add\(\{
                    'modifier_id': modId,
                    'option_id': optId,
                  \}\);
                \}
              \}\);

              context\.read<CartCubit>\(\)\.addToCart\(
                restaurantId: '',
                menuItemId: product\.id,
                name: product\.name,
                price: unitPrice,
                quantity: _quantity,
                selectedModifiers: modifiers,
                notes: _notes,
              \);"""

new_code = """              final List<int> modifierIdsList = [];
              _selectedOptions.forEach((modId, selectedIds) {
                for (final optId in selectedIds) {
                  final idInt = int.tryParse(optId);
                  if (idInt != null) {
                    modifierIdsList.add(idInt);
                  }
                }
              });

              context.read<CartCubit>().addItem(
                productId: product.id.toString(),
                quantity: _quantity,
                optionValueIds: modifierIdsList,
              );"""

content = re.sub(old_code, new_code, content, flags=re.DOTALL)

with open('lib/features/product/presentation/pages/product_details_screen.dart', 'w') as f:
    f.write(content)


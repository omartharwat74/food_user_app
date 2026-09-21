import re

with open('lib/features/product/presentation/pages/product_details_screen.dart', 'r') as f:
    content = f.read()

# Replace the onSubmit logic
old_onsubmit = r"""            onSubmit: \(\) \{
                            final List<int> modifierIdsList = \[\];
              _selectedOptions\.forEach\(\(modId, selectedIds\) \{
                for \(final optId in selectedIds\) \{
                  final idInt = int\.tryParse\(optId\);
                  if \(idInt != null\) \{
                    modifierIdsList\.add\(idInt\);
                  \}
                \}
              \}\);

              context\.read<CartCubit>\(\)\.addItem\(
                productId: product\.id\.toString\(\),
                quantity: _quantity,
                optionValueIds: modifierIdsList,
              \);
              // NOT popping context here! The BlocListener in parent screen handles it\.

            \},"""

new_onsubmit = """            onSubmit: () async {
              final List<int> modifierIdsList = [];
              _selectedOptions.forEach((modId, selectedIds) {
                for (final optId in selectedIds) {
                  final idInt = int.tryParse(optId);
                  if (idInt != null) {
                    modifierIdsList.add(idInt);
                  }
                }
              });

              try {
                await context.read<CartCubit>().addItem(
                  productId: product.id.toString(),
                  quantity: _quantity,
                  optionValueIds: modifierIdsList,
                );
                
                if (!context.mounted) return;

                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إضافة المنتج للسلة بنجاح', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 3),
                  ),
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('حدث خطأ أثناء الإضافة'), backgroundColor: Colors.red),
                );
              }
            },"""

content = re.sub(old_onsubmit, new_onsubmit, content)

with open('lib/features/product/presentation/pages/product_details_screen.dart', 'w') as f:
    f.write(content)


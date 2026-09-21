import re

def update_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()
        
    if 'BlocListener<CartCubit, CartState>' not in content:
        return
        
    print(f'Updating {filepath}')
    
    # We need to add `loaded:` and `error:` handlers inside `state.maybeWhen(`
    
    loaded_code = """              loaded: (cart, promo) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إضافة المنتج للسلة بنجاح'),
                    backgroundColor: Colors.green,
                  ),
                );
                if (!(ModalRoute.of(context)?.isCurrent ?? true)) {
                  Navigator.of(context).pop();
                }
              },
              error: (cart, promo, message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: Colors.red,
                  ),
                );
              },
"""

    if 'loaded: (cart, promo) {' not in content:
        # insert after `state.maybeWhen(`
        # But wait, cart_screen.dart doesn't have maybeWhen with conflict!
        
        if 'conflict: (cart, newRestaurantId' in content:
            content = content.replace('state.maybeWhen(', 'state.maybeWhen(\n' + loaded_code)
            with open(filepath, 'w') as f:
                f.write(content)
                
import os
for root, _, files in os.walk('lib/features'):
    for file in files:
        if file.endswith('.dart'):
            update_file(os.path.join(root, file))


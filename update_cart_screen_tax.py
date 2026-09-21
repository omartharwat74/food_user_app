import re

with open('lib/features/cart/presentation/pages/cart_screen.dart', 'r') as f:
    content = f.read()

# Add tax variable
content = re.sub(r'                final delivery = cart\.deliveryFee\.round\(\);\n                final discount = cart\.discount\.round\(\);', r'                final delivery = cart.deliveryFee.round();\n                final tax = cart.tax.round();\n                final discount = cart.discount.round();', content)

# Pass tax to CartSummary
content = re.sub(r'                          delivery: delivery,\n                          discount: discount,', r'                          delivery: delivery,\n                          tax: tax,\n                          discount: discount,', content)

with open('lib/features/cart/presentation/pages/cart_screen.dart', 'w') as f:
    f.write(content)


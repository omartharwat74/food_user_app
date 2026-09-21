import re

with open('lib/features/cart/presentation/cubit/cart_cubit.dart', 'r') as f:
    content = f.read()

content = re.sub(r'          deliveryFee: currentCart\.deliveryFee,\n          discount: promo\.discountAmount,', r'          deliveryFee: currentCart.deliveryFee,\n          tax: currentCart.tax,\n          discount: promo.discountAmount,', content)

with open('lib/features/cart/presentation/cubit/cart_cubit.dart', 'w') as f:
    f.write(content)


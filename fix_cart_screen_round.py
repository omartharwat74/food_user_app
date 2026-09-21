import re

with open('lib/features/cart/presentation/pages/cart_screen.dart', 'r') as f:
    content = f.read()

content = content.replace('final subtotal = cart.subtotal.round();', 'final subtotal = cart.subtotal;')
content = content.replace('final delivery = cart.deliveryFee.round();', 'final delivery = cart.deliveryFee;')
content = content.replace('final tax = cart.tax.round();', 'final tax = cart.tax;')
content = content.replace('final discount = cart.discount.round();', 'final discount = cart.discount;')
content = content.replace('final total = cart.total.round();', 'final total = cart.total;')

with open('lib/features/cart/presentation/pages/cart_screen.dart', 'w') as f:
    f.write(content)


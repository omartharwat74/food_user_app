import re

with open('lib/features/cart/data/models/cart_response_dto.dart', 'r') as f:
    content = f.read()

content = content.replace('price: (item.unitPrice ?? item.price ?? 0).toInt(),', 'price: (item.unitPrice ?? item.price ?? 0).toDouble(),')

with open('lib/features/cart/data/models/cart_response_dto.dart', 'w') as f:
    f.write(content)


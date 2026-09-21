import re

with open('lib/features/cart/domain/entities/cart_item.dart', 'r') as f:
    content = f.read()

content = re.sub(r'  final int price;', r'  final double price;', content)
content = re.sub(r'    int\? price,', r'    double? price,', content)

with open('lib/features/cart/domain/entities/cart_item.dart', 'w') as f:
    f.write(content)


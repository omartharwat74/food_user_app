import re

with open('lib/features/cart/domain/entities/cart.dart', 'r') as f:
    content = f.read()

# Add final double tax;
content = re.sub(r'  final double discount;', r'  final double tax;\n  final double discount;', content)

# Add to constructor
content = re.sub(r'    required this\.deliveryFee,\n    required this\.discount,', r'    required this.deliveryFee,\n    required this.tax,\n    required this.discount,', content)

# Add to empty constructor
content = re.sub(r'        deliveryFee = 0\.0,\n        discount = 0\.0,', r'        deliveryFee = 0.0,\n        tax = 0.0,\n        discount = 0.0,', content)

# Add to props
content = re.sub(r'        deliveryFee,\n        discount,', r'        deliveryFee,\n        tax,\n        discount,', content)

with open('lib/features/cart/domain/entities/cart.dart', 'w') as f:
    f.write(content)


import re

with open('lib/features/home/presentation/pages/search_screen.dart', 'r') as f:
    content = f.read()

content = content.replace('priceValue: item.price.toInt(),', 'priceValue: item.price.toDouble(),')
content = content.replace('priceValue: 190,', 'priceValue: 190.0,')
content = content.replace('priceValue: 45,', 'priceValue: 45.0,')
content = content.replace('final int priceValue;', 'final double priceValue;')

with open('lib/features/home/presentation/pages/search_screen.dart', 'w') as f:
    f.write(content)


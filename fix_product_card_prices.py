import re

def process(filepath):
    with open(filepath, 'r') as f:
        content = f.read()
    
    if "import 'package:food_user_app/core/utils/price_extension.dart';" not in content:
        content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:food_user_app/core/utils/price_extension.dart';")
        
    content = content.replace('item.price.toStringAsFixed(0)', 'item.price.toFormattedPrice()')
    content = content.replace('price.toStringAsFixed(0)', 'price.toFormattedPrice()')
    
    with open(filepath, 'w') as f:
        f.write(content)

process('lib/features/restaurant/presentation/widgets/product_card.dart')
process('lib/features/restaurant/presentation/widgets/menu_item_tile.dart')


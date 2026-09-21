import re

def process(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    if "import 'package:food_user_app/core/utils/price_extension.dart';" not in content:
        content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:food_user_app/core/utils/price_extension.dart';")

    content = content.replace('p.price.toStringAsFixed(2)', 'p.price.toFormattedPrice()')
    content = content.replace('p.originalPrice!.toStringAsFixed(2)', 'p.originalPrice!.toFormattedPrice()')
    content = content.replace('market.deliveryFee.toStringAsFixed(2)', 'market.deliveryFee.toFormattedPrice()')

    with open(filepath, 'w') as f:
        f.write(content)

process('lib/features/market/presentation/widgets/product_card.dart')
process('lib/features/market/presentation/widgets/market_card.dart')

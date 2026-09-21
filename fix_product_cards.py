import re
import os

def process_file(filepath):
    if not os.path.exists(filepath):
        return
    with open(filepath, 'r') as f:
        content = f.read()
    
    if "PriceFormatter" not in content:
        import_statement = "import 'package:food_user_app/l10n/app_localizations.dart';\nimport 'package:food_user_app/core/utils/price_formatter.dart';"
        content = content.replace("import 'package:food_user_app/l10n/app_localizations.dart';", import_statement)
    
    # Replace .toInt().toString() or .round().toString() or .toStringAsFixed(0)
    # Actually, we can just replace the specific text blocks. Let's see what they have.
    content = re.sub(r'\$\{([a-zA-Z0-9_\.]+)\.round\(\)\}', r'${PriceFormatter.format(\1)}', content)
    content = re.sub(r'\$\{([a-zA-Z0-9_\.]+)\.toInt\(\)\}', r'${PriceFormatter.format(\1)}', content)
    
    # Check for direct calls
    content = content.replace('product.price.round().toString()', 'PriceFormatter.format(product.price)')
    content = content.replace('product.price.toInt().toString()', 'PriceFormatter.format(product.price)')
    content = content.replace('item.price.round().toString()', 'PriceFormatter.format(item.price)')
    content = content.replace('item.price.toInt().toString()', 'PriceFormatter.format(item.price)')
    
    with open(filepath, 'w') as f:
        f.write(content)

process_file('lib/features/restaurant/presentation/widgets/product_card.dart')
process_file('lib/features/restaurant/presentation/widgets/menu_item_tile.dart')
process_file('lib/features/market/presentation/widgets/product_card.dart')
process_file('lib/features/product/presentation/pages/product_details_screen.dart')


import re
import os

def process_file(filepath):
    if not os.path.exists(filepath): return
    with open(filepath, 'r') as f:
        content = f.read()

    if "import 'package:food_user_app/core/utils/price_formatter.dart';" not in content:
        content = content.replace("import 'package:food_user_app/l10n/app_localizations.dart';", "import 'package:food_user_app/l10n/app_localizations.dart';\nimport 'package:food_user_app/core/utils/price_formatter.dart';")

    # For search_screen.dart
    content = content.replace('l10n.cartPrice(190)', 'l10n.cartPrice("190")')
    
    # For checkout_screen.dart
    content = content.replace('l10n.cartPrice(total)', 'l10n.cartPrice(PriceFormatter.formatNum(total))')

    with open(filepath, 'w') as f:
        f.write(content)

process_file('lib/features/home/presentation/pages/search_screen.dart')
process_file('lib/features/checkout/presentation/pages/checkout_screen.dart')


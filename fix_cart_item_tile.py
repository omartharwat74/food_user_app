import re

with open('lib/features/cart/presentation/widgets/cart_item_tile.dart', 'r') as f:
    content = f.read()

import_statement = "import 'package:food_user_app/l10n/app_localizations.dart';\nimport 'package:food_user_app/core/utils/price_formatter.dart';"
content = content.replace("import 'package:food_user_app/l10n/app_localizations.dart';", import_statement)

content = content.replace('l10n.cartPrice(item.price)', 'l10n.cartPrice(PriceFormatter.format(item.price))')

with open('lib/features/cart/presentation/widgets/cart_item_tile.dart', 'w') as f:
    f.write(content)


import re

with open('lib/features/product/presentation/pages/product_details_screen.dart', 'r') as f:
    content = f.read()

content = content.replace('final int unitPrice = (calculatedBasePrice + addonsTotal).toInt();', 'final double unitPrice = calculatedBasePrice + addonsTotal;')
content = content.replace('final int total = unitPrice * _quantity;', 'final double total = unitPrice * _quantity;')

# _ProductBottomBar needs to accept double!
content = content.replace('  final int unitPrice;\n  final int total;', '  final double unitPrice;\n  final double total;')

# l10n.cartPrice requires String now
if "import 'package:food_user_app/core/utils/price_formatter.dart';" not in content:
    content = content.replace("import 'package:food_user_app/l10n/app_localizations.dart';", "import 'package:food_user_app/l10n/app_localizations.dart';\nimport 'package:food_user_app/core/utils/price_formatter.dart';")

content = content.replace('l10n.cartPrice(unitPrice)', 'l10n.cartPrice(PriceFormatter.format(unitPrice))')
content = content.replace('l10n.cartPrice(total)', 'l10n.cartPrice(PriceFormatter.format(total))')

with open('lib/features/product/presentation/pages/product_details_screen.dart', 'w') as f:
    f.write(content)


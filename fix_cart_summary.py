import re

with open('lib/features/cart/presentation/widgets/cart_summary.dart', 'r') as f:
    content = f.read()

content = content.replace('  final int subtotal;', '  final double subtotal;')
content = content.replace('  final int delivery;', '  final double delivery;')
content = content.replace('  final int tax;', '  final double tax;')
content = content.replace('  final int discount;', '  final double discount;')
content = content.replace('  final int total;', '  final double total;')

# Replace l10n.cartPrice(...) with l10n.cartPrice(PriceFormatter.format(...))
# Wait, I changed l10n to accept String! So it must be wrapped in PriceFormatter.formatNum / format
# I need to import price formatter in cart_summary.dart

import_statement = "import 'package:food_user_app/l10n/app_localizations.dart';\nimport 'package:food_user_app/core/utils/price_formatter.dart';"
content = content.replace("import 'package:food_user_app/l10n/app_localizations.dart';", import_statement)

content = content.replace('l10n.cartPrice(subtotal)', 'l10n.cartPrice(PriceFormatter.format(subtotal))')
content = content.replace('l10n.cartPrice(delivery)', 'l10n.cartPrice(PriceFormatter.format(delivery))')
content = content.replace('l10n.cartPrice(tax)', 'l10n.cartPrice(PriceFormatter.format(tax))')
content = content.replace('l10n.cartPrice(discount)', 'l10n.cartPrice(PriceFormatter.format(discount))')
content = content.replace('l10n.cartPrice(total)', 'l10n.cartPrice(PriceFormatter.format(total))')

with open('lib/features/cart/presentation/widgets/cart_summary.dart', 'w') as f:
    f.write(content)


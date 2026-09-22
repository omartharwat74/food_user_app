import re

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'r') as f:
    content = f.read()

# Fix delivery price
content = content.replace("? '${restaurant.deliveryFee.toFormattedPrice()} رس'", "? '${restaurant.deliveryFee.toFormattedPrice()} ج.م'")
content = content.replace(": '${restaurant.deliveryFee.toFormattedPrice()} SAR'", ": 'EGP ${restaurant.deliveryFee.toFormattedPrice()}'")

# Fix minimum order
content = content.replace("Localizations.localeOf(context).languageCode == 'ar' ? '0 رس' : '0 SAR'", "isArabic ? '0 ج.م' : 'EGP 0'")

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'w') as f:
    f.write(content)

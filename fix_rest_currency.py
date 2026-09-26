import os
import re

def fix_file(filepath, replacements):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    for old, new in replacements:
        content = content.replace(old, new)
        
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

fix_file('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', [
    (r"isArabic ? '0 ج.م' : 'EGP 0'", r"AppLocalizations.of(context)!.priceWithCurrency('0')"),
    (r"isArabic ? '${restaurant.deliveryFee.toFormattedPrice()} ج.م' : 'EGP ${restaurant.deliveryFee.toFormattedPrice()}'", r"AppLocalizations.of(context)!.priceWithCurrency(restaurant.deliveryFee.toFormattedPrice())"),
    (r"isArabic\n                  ? '${restaurant.deliveryFee.toFormattedPrice()} ج.م'\n                  : 'EGP ${restaurant.deliveryFee.toFormattedPrice()}'", r"AppLocalizations.of(context)!.priceWithCurrency(restaurant.deliveryFee.toFormattedPrice())"),
])

fix_file('lib/features/restaurant/presentation/pages/restaurant_detail_screen.dart', [
    (r"isArabic\n                              ? '${restaurant.deliveryFee} ج.م'\n                              : 'EGP ${restaurant.deliveryFee}'", r"AppLocalizations.of(context)!.priceWithCurrency(restaurant.deliveryFee.toString())"),
    (r"isArabic\n                          ? '${restaurant.deliveryFee} ج.م'\n                          : 'EGP ${restaurant.deliveryFee}'", r"AppLocalizations.of(context)!.priceWithCurrency(restaurant.deliveryFee.toString())"),
])

fix_file('lib/features/restaurant/presentation/widgets/menu_item_tile.dart', [
    (r"badgeText = isArabic\n          ? 'خصم ${item.discountValue.toFormattedPrice()}%'\n          : 'Discount ${item.discountValue.toFormattedPrice()}%';", 
     r"badgeText = AppLocalizations.of(context)!.discount + ' ' + item.discountValue.toFormattedPrice() + '%';"),
    (r"badgeText = isArabic\n          ? 'خصم ${item.discountValue.toFormattedPrice()} ج.م'\n          : 'Discount EGP ${item.discountValue.toFormattedPrice()}';", 
     r"badgeText = AppLocalizations.of(context)!.discount + ' ' + AppLocalizations.of(context)!.priceWithCurrency(item.discountValue.toFormattedPrice());"),
])

print("Fixed restaurant currency/strings.")

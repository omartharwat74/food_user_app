import os
import re

def fix_file(filepath, replacements):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    for old, new in replacements:
        content = content.replace(old, new)
        
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

# restaurant_detail_screen
fix_file('lib/features/restaurant/presentation/pages/restaurant_detail_screen.dart', [
    (r"? '${restaurant.deliveryFee} ج.م'", r"? AppLocalizations.of(context)!.priceWithCurrency(restaurant.deliveryFee.toString())"),
])

# restaurant_rate_screen
fix_file('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', [
    (r"? '${restaurant.deliveryFee.toFormattedPrice()} ج.م'", r"? AppLocalizations.of(context)!.priceWithCurrency(restaurant.deliveryFee.toFormattedPrice())"),
])

# menu_item_tile
fix_file('lib/features/restaurant/presentation/widgets/menu_item_tile.dart', [
    (r"? 'خصم ${item.discountValue.toFormattedPrice()}%'", r"? (AppLocalizations.of(context)!.discount + ' ' + item.discountValue.toFormattedPrice() + '%')"),
    (r"? 'خصم ${item.discountValue.toFormattedPrice()} ج.م'", r"? (AppLocalizations.of(context)!.discount + ' ' + AppLocalizations.of(context)!.priceWithCurrency(item.discountValue.toFormattedPrice()))"),
])

# address_selection_screen
fix_file('lib/features/checkout/presentation/pages/address_selection_screen.dart', [
    (r"'مبنى : ${address.buildingNumber ?? ''} / شقة : ${address.apartment ?? ''} / الدور : ${address.floor ?? ''}'", r"AppLocalizations.of(context)!.addressDetailsFormat(address.buildingNumber ?? '', address.apartment ?? '', address.floor ?? '')"),
])

print("Fixed missed strings.")

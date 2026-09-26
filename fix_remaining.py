import os

def fix_file(filepath, replacements):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    for old, new in replacements:
        content = content.replace(old, new)
        
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

fix_file('lib/features/profile/presentation/pages/add_edit_address_screen.dart', [
    (r"return 'هذا الحقل مطلوب';", r"return AppLocalizations.of(context)!.fieldRequired;"),
])

fix_file('lib/features/profile/presentation/pages/favourites_screen.dart', [
    (r"? '\u200E${item.deliveryTimeMin} - ${item.deliveryTimeMax}\u200E دقيقة'", 
     r"? '\u200E${item.deliveryTimeMin} - ${item.deliveryTimeMax}\u200E ${AppLocalizations.of(context)!.minutes}'"),
])

fix_file('lib/features/home/presentation/pages/search_screen.dart', [
    (r"? '${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} دقيقة'", 
     r"? '${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} ${AppLocalizations.of(context)!.minutes}'"),
])

print("Fixed remaining strings.")

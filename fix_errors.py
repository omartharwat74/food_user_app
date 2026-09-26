import re

def add_import_if_missing(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    if "import '../../../../l10n/app_localizations.dart';" not in content:
        content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport '../../../../l10n/app_localizations.dart';")
        
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

add_import_if_missing('lib/features/market/presentation/widgets/market_not_found_widget.dart')
add_import_if_missing('lib/features/market/presentation/widgets/product_card.dart')

# Fix invalid constants
def remove_const(filepath, const_str, target_str):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    content = content.replace(const_str, target_str)
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

# store_details_screen.dart line 39: invalid_constant
# It might be `const Text(AppLocalizations.of(context)!...)`
def fix_invalid_consts(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
        
    content = re.sub(r"const\s+Text\(\s*AppLocalizations", r"Text(AppLocalizations", content)
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

fix_invalid_consts('lib/features/product/presentation/pages/product_details_screen.dart')
fix_invalid_consts('lib/features/store/presentation/pages/store_details_screen.dart')

print("Fixed errors.")

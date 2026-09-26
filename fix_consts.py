import re

def fix_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # import in markets_list_screen
    if "markets_list_screen.dart" in filepath:
        if "import '../../../../l10n/app_localizations.dart';" not in content:
            content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport '../../../../l10n/app_localizations.dart';")

    # const SnackBar(...)
    content = re.sub(r"const SnackBar\(\s*content:\s*Text\(\s*AppLocalizations", r"SnackBar(\ncontent: Text(\nAppLocalizations", content)
    
    # const Text(...) already done, but let's make sure there are no other const before AppLocalizations
    content = re.sub(r"const\s+Text\(\s*AppLocalizations", r"Text(AppLocalizations", content)

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

fix_file('lib/features/product/presentation/pages/product_details_screen.dart')
fix_file('lib/features/store/presentation/pages/store_details_screen.dart')
fix_file('lib/features/market/presentation/pages/markets_list_screen.dart')

print("Fixed consts and imports.")

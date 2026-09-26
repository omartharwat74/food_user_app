import re

# 1. cart_floating_banner.dart
cart_banner_path = 'lib/features/cart/presentation/widgets/cart_floating_banner.dart'
with open(cart_banner_path, 'r', encoding='utf-8') as f:
    content = f.read()

if "import 'package:food_user_app/l10n/app_localizations.dart';" not in content:
    content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:food_user_app/l10n/app_localizations.dart';")

with open(cart_banner_path, 'w', encoding='utf-8') as f:
    f.write(content)

# 2. checkout_screen.dart
checkout_path = 'lib/features/checkout/presentation/pages/checkout_screen.dart'
with open(checkout_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = re.sub(r"const\s+Text\(\s*AppLocalizations", r"Text(AppLocalizations", content)

with open(checkout_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Fixed cart_floating_banner and checkout_screen.")

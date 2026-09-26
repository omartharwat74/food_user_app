import re
import os

filepath = 'lib/features/market/presentation/widgets/market_empty_state.dart'
with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

# add import if not exists
if 'app_localizations.dart' not in content:
    content = content.replace("import '../../../../core/theme/app_colors.dart';", "import '../../../../core/theme/app_colors.dart';\nimport '../../../../l10n/app_localizations.dart';")

content = re.sub(
    r"message \?\?\s*\(\s*isArabic\s*\?\s*'لم نتمكن من العثور على أي منتجات أو أقسام هنا\.'\s*:\s*'We could not find any products or categories here\.'\s*\)",
    r"message ?? AppLocalizations.of(context)!.noProductsOrSections",
    content
)

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)

print("Fixed market_empty_state.dart")

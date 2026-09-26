import re

filepath = 'lib/features/main/presentation/pages/main_layout.dart'
with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

# Add imports if missing
imports = [
    "import 'package:food_user_app/features/home/presentation/cubit/banner_cubit.dart';",
    "import 'package:food_user_app/features/home/presentation/cubit/home_cubits.dart';",
    "import 'package:food_user_app/core/localization/app_locale_scope.dart';"
]
for imp in imports:
    if imp not in content:
        content = content.replace("import 'package:food_user_app/l10n/app_localizations.dart';", f"import 'package:food_user_app/l10n/app_localizations.dart';\n{imp}")

# Insert didChangeDependencies
insertion = """
  Locale? _previousLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentLocale = AppLocaleScope.of(context).locale;
    if (_previousLocale != null && _previousLocale != currentLocale) {
      context.read<BannerCubit>().getActiveBanners();
      context.read<SectionsCubit>().fetchSections();
      context.read<SpotlightsCubit>().fetchSpotlights();
      context.read<CartCubit>().getCart();
    }
    _previousLocale = currentLocale;
  }

"""

if "void didChangeDependencies" not in content:
    content = content.replace("int _selectedIndex = 0;", f"int _selectedIndex = 0;\n{insertion}")

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)

print("Patched main_layout.dart")

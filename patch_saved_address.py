import re

filepath = 'lib/features/profile/domain/models/saved_address.dart'
with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

getter = """  final bool isDefault;

  String get iconAsset {
    final type = addressType?.toLowerCase();
    if (type == 'work') return 'assets/images/icons/address/address_type_work.png';
    if (type == 'other' || type == 'office') return 'assets/images/icons/address/address_type_office.png';
    return 'assets/images/icons/address/address_type_home.png';
  }

  String title(Locale locale) => _localized(locale, ar: titleAr, en: titleEn);"""

if "String get iconAsset {" not in content:
    content = content.replace("  final bool isDefault;\n\n  String title(Locale locale) => _localized(locale, ar: titleAr, en: titleEn);", getter)

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)

print("Patched saved_address.dart")

import re

filepath = 'lib/features/profile/presentation/widgets/address_type_selector.dart'
with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

# Add AppAssets import
if "import 'package:food_user_app/core/constants/app_assets.dart';" not in content:
    content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:food_user_app/core/constants/app_assets.dart';")

# Update types array to use Image Assets
old_types = """    final types = [
      {'key': 'primary', 'label': l10n.addressTypeHome, 'icon': Icons.home_outlined},
      {'key': 'work', 'label': l10n.addressTypeWork, 'icon': Icons.business_center_outlined},
      {'key': 'other', 'label': l10n.addressTypeOffice, 'icon': Icons.domain_outlined},
    ];"""

new_types = """    final types = [
      {'key': 'primary', 'label': l10n.addressTypeHome, 'icon': AppAssets.addressTypeHome},
      {'key': 'work', 'label': l10n.addressTypeWork, 'icon': AppAssets.addressTypeWork},
      {'key': 'other', 'label': l10n.addressTypeOffice, 'icon': AppAssets.addressTypeOffice},
    ];"""

content = content.replace(old_types, new_types)

# Update Text color
content = content.replace("color: AppColors.text,", "color: AppColors.onSurface(context),")

# Replace Icon widget with Image.asset
old_icon_widget = """                      Icon(
                        type['icon'] as IconData,
                        size: 18,
                        color: isSelected ? AppColors.primary : AppColors.paragraph(context),
                      ),"""

new_icon_widget = """                      Image.asset(
                        type['icon'] as String,
                        width: 18,
                        height: 18,
                        color: isSelected ? AppColors.primary : AppColors.paragraph(context),
                      ),"""

content = content.replace(old_icon_widget, new_icon_widget)

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)

print("Updated AddressTypeSelector.")

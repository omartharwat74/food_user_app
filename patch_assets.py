import re

filepath = 'lib/core/constants/app_assets.dart'
with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

new_assets = """  static const addressTypeHome = 'assets/images/icons/address/address_type_home.png';
  static const addressTypeWork = 'assets/images/icons/address/address_type_work.png';
  static const addressTypeOffice = 'assets/images/icons/address/address_type_office.png';
"""

if "addressTypeHome" not in content:
    content = content.replace("  static const addressMapIcon = 'assets/images/icons/address/map.svg';", 
                              "  static const addressMapIcon = 'assets/images/icons/address/map.svg';\n" + new_assets)

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)

print("Updated AppAssets.")

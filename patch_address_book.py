import re

filepath = 'lib/features/profile/presentation/pages/address_book_screen.dart'
with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

old_svg = """                  SvgPicture.asset(
                    AppAssets.addressHomeIcon,
                    width: 20,
                    height: 20,
                  ),"""

new_img = """                  Image.asset(
                    address.iconAsset,
                    width: 20,
                    height: 20,
                    color: AppColors.primary,
                  ),"""

content = content.replace(old_svg, new_img)

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)

print("Patched address_book_screen.dart")

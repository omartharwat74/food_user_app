import re

filepath = 'lib/features/checkout/presentation/pages/address_selection_screen.dart'
with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

old_svg = """                      SvgPicture.asset(
                        AppAssets.addressHomeIcon,
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          AppColors.primary,
                          BlendMode.srcIn,
                        ),
                      ),"""

new_img = """                      Image.asset(
                        address.iconAsset,
                        width: 20,
                        height: 20,
                        color: AppColors.primary,
                      ),"""

content = content.replace(old_svg, new_img)

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)

print("Patched address_selection_screen.dart")

import re

with open('lib/features/profile/presentation/pages/favourites_screen.dart', 'r') as f:
    content = f.read()

old_block = """    final String timeText =
      '';"""
new_block = """    final String timeText = '';"""
content = content.replace(old_block, new_block)

old_text = """            DeliveryTimeText(
              minTime: item.deliveryTimeMin,
              maxTime: item.deliveryTimeMax,
              style: AppTextStyles.caption(context).copyWith(
                fontSize: 10,
                height: 1.25,
              ),
            ),"""
content = content.replace(old_text, "")

with open('lib/features/profile/presentation/pages/favourites_screen.dart', 'w') as f:
    f.write(content)

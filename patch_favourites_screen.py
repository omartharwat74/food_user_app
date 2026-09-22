import re

with open('lib/features/profile/presentation/pages/favourites_screen.dart', 'r') as f:
    content = f.read()

if 'delivery_time_text.dart' not in content:
    content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:food_user_app/core/widgets/delivery_time_text.dart';")

# 1. First usage (restaurant)
old_usage_1 = """      isArabic
        ? '${item.deliveryTimeMin}-${item.deliveryTimeMax} دقيقة'
        : '${item.deliveryTimeMin}-${item.deliveryTimeMax} min';"""

new_usage_1 = "      '';"

content = content.replace(old_usage_1, new_usage_1)

old_text_1 = """            Text(
              timeText,
              style: AppTextStyles.caption(
                context,
              ).copyWith(fontSize: 10, height: 1.25),
            ),"""

new_text_1 = """            DeliveryTimeText(
              minTime: item.deliveryTimeMin,
              maxTime: item.deliveryTimeMax,
              style: AppTextStyles.caption(context).copyWith(
                fontSize: 10,
                height: 1.25,
              ),
            ),"""
content = content.replace(old_text_1, new_text_1)


# 2. Second usage (market)
old_usage_2 = """      isArabic
        ? '${item.deliveryTimeMin}-${item.deliveryTimeMax} دقيقة'
        : '${item.deliveryTimeMin}-${item.deliveryTimeMax} min';"""

new_usage_2 = "      '';"
content = content.replace(old_usage_2, new_usage_2)

old_text_2 = """            Text(
              timeText,
              style: AppTextStyles.caption(
                context,
              ).copyWith(fontSize: 10, height: 1.25),
            ),"""

new_text_2 = """            DeliveryTimeText(
              minTime: item.deliveryTimeMin,
              maxTime: item.deliveryTimeMax,
              style: AppTextStyles.caption(context).copyWith(
                fontSize: 10,
                height: 1.25,
              ),
            ),"""

content = content.replace(old_text_2, new_text_2)

# Oh wait, timeText might be declared and used elsewhere!
with open('lib/features/profile/presentation/pages/favourites_screen.dart', 'w') as f:
    f.write(content)

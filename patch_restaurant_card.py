import re

with open('lib/features/restaurant/presentation/widgets/restaurant_card.dart', 'r') as f:
    content = f.read()

if 'delivery_time_text.dart' not in content:
    content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:food_user_app/core/widgets/delivery_time_text.dart';")

# 1. Update first usage
old_usage_1 = """            Text(
              isArabic
                  ? '${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} دقيقة'
                  : '${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} min',
              style: AppTextStyles.body(context).copyWith(
                color: AppColors.onSurface(context).withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),"""

new_usage_1 = """            DeliveryTimeText(
              minTime: restaurant.deliveryTimeMin,
              maxTime: restaurant.deliveryTimeMax,
              style: AppTextStyles.body(context).copyWith(
                color: AppColors.onSurface(context).withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),"""
content = content.replace(old_usage_1, new_usage_1)

# 2. Update second usage
old_usage_2 = """                          Expanded(
                            child: Text(
                              isArabic
                                  ? "${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} دقيقة"
                                  : "${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} min",
                              textAlign:
                                  isArabic ? TextAlign.end : TextAlign.start,
                              style: AppTextStyles.caption(context).copyWith(
                                fontSize: 10,
                                height: 1.25,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),"""

new_usage_2 = """                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                              child: DeliveryTimeText(
                                minTime: restaurant.deliveryTimeMin,
                                maxTime: restaurant.deliveryTimeMax,
                                style: AppTextStyles.caption(context).copyWith(
                                  fontSize: 10,
                                  height: 1.25,
                                ),
                              ),
                            ),
                          ),"""
content = content.replace(old_usage_2, new_usage_2)

with open('lib/features/restaurant/presentation/widgets/restaurant_card.dart', 'w') as f:
    f.write(content)

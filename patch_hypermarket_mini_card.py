import re

with open('lib/features/market/presentation/widgets/hypermarket_mini_card.dart', 'r') as f:
    content = f.read()

if 'delivery_time_text.dart' not in content:
    content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:food_user_app/core/widgets/delivery_time_text.dart';")

old_usage = """                  Text(
                    isArabic
                        ? '${market.deliveryTimeMin}-${market.deliveryTimeMax} دقيقة'
                        : '${market.deliveryTimeMin}-${market.deliveryTimeMax} min',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption(context).copyWith(
                      fontSize: 10,
                      color: AppColors.paragraph(context).withValues(alpha: 0.8),
                    ),
                  ),"""

new_usage = """                  DeliveryTimeText(
                    minTime: market.deliveryTimeMin,
                    maxTime: market.deliveryTimeMax,
                    style: AppTextStyles.caption(context).copyWith(
                      fontSize: 10,
                      color: AppColors.paragraph(context).withValues(alpha: 0.8),
                    ),
                  ),"""
content = content.replace(old_usage, new_usage)

with open('lib/features/market/presentation/widgets/hypermarket_mini_card.dart', 'w') as f:
    f.write(content)

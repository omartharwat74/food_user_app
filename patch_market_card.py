import re

with open('lib/features/market/presentation/widgets/market_card.dart', 'r') as f:
    content = f.read()

if 'delivery_time_text.dart' not in content:
    content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:food_user_app/core/widgets/delivery_time_text.dart';")

old_usage = """                              Expanded(
                                child: Text(
                                  isArabic
                                      ? '${market.deliveryTimeMin}-${market.deliveryTimeMax} دقيقة'
                                      : '${market.deliveryTimeMin}-${market.deliveryTimeMax} min',
                                  textAlign:
                                      isArabic ? TextAlign.end : TextAlign.start,
                                  style:
                                      AppTextStyles.caption(context).copyWith(
                                    fontSize: 10,
                                    height: 1.25,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),"""

new_usage = """                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                                  child: DeliveryTimeText(
                                    minTime: market.deliveryTimeMin,
                                    maxTime: market.deliveryTimeMax,
                                    style: AppTextStyles.caption(context).copyWith(
                                      fontSize: 10,
                                      height: 1.25,
                                    ),
                                  ),
                                ),
                              ),"""
content = content.replace(old_usage, new_usage)

with open('lib/features/market/presentation/widgets/market_card.dart', 'w') as f:
    f.write(content)

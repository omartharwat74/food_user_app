import re

with open('lib/features/restaurant/presentation/widgets/restaurant_card.dart', 'r') as f:
    content = f.read()

old = """                        Text(
                          isArabic
                              ? "${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} دقيقة"
                              : "${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} min",
                          style: AppTextStyles.caption(context).copyWith(
                            fontSize: 10,
                            height: 1.25,
                            color: AppColors.onSurface(context),
                          ),
                        ),"""

new = """                        DeliveryTimeText(
                          minTime: restaurant.deliveryTimeMin,
                          maxTime: restaurant.deliveryTimeMax,
                          style: AppTextStyles.caption(context).copyWith(
                            fontSize: 10,
                            height: 1.25,
                            color: AppColors.onSurface(context),
                          ),
                        ),"""

content = content.replace(old, new)
with open('lib/features/restaurant/presentation/widgets/restaurant_card.dart', 'w') as f:
    f.write(content)

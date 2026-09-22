with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'r') as f:
    content = f.read()

old_style = """          valueWidget: DeliveryTimeText(
            minTime: restaurant.deliveryTimeMin,
            maxTime: restaurant.deliveryTimeMax,
            style: AppTextStyles.body(context).copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.4,
              color: AppColors.primary,
            ),
          ),"""

new_style = """          valueWidget: DeliveryTimeText(
            minTime: restaurant.deliveryTimeMin,
            maxTime: restaurant.deliveryTimeMax,
            style: AppTextStyles.caption(context).copyWith(
              color: AppColors.onSurface(context),
              fontSize: 12,
              height: 1.3,
            ),
          ),"""
content = content.replace(old_style, new_style)

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'w') as f:
    f.write(content)

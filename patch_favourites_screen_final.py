import re

with open('lib/features/profile/presentation/pages/favourites_screen.dart', 'r') as f:
    content = f.read()

# 1. Add import
if 'delivery_time_text.dart' not in content:
    content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:food_user_app/core/widgets/delivery_time_text.dart';")

# 2. Fix _DeliveryTimeLabel
old_label = """class _DeliveryTimeLabel extends StatelessWidget {
  const _DeliveryTimeLabel({required this.deliveryTime});

  final String deliveryTime;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final icon = SvgPicture.asset(
      AppAssets.favoriteTimeIcon,
      width: FavouritesScreen._metaIconSize,
      height: FavouritesScreen._metaIconSize,
      colorFilter: ColorFilter.mode(
        AppColors.onSurface(context),
        BlendMode.srcIn,
      ),
    );
    final label = Text(
      deliveryTime,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
      style: AppTextStyles.caption(context).copyWith(
        color: AppColors.onSurface(context),
        fontSize: 10,
        fontWeight: FontWeight.w400,
        height: 1.25,
      ),
    );

    return Row(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      mainAxisSize: MainAxisSize.min,
      children: [icon, const SizedBox(width: 4), label],
    );
  }
}"""
new_label = """class _DeliveryTimeLabel extends StatelessWidget {
  const _DeliveryTimeLabel({required this.minTime, required this.maxTime});

  final int minTime;
  final int maxTime;

  @override
  Widget build(BuildContext context) {
    final icon = SvgPicture.asset(
      AppAssets.favoriteTimeIcon,
      width: FavouritesScreen._metaIconSize,
      height: FavouritesScreen._metaIconSize,
      colorFilter: ColorFilter.mode(
        AppColors.onSurface(context),
        BlendMode.srcIn,
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon, 
        const SizedBox(width: 4), 
        DeliveryTimeText(
          minTime: minTime,
          maxTime: maxTime,
          style: AppTextStyles.caption(context).copyWith(
            color: AppColors.onSurface(context),
            fontSize: 10,
            fontWeight: FontWeight.w400,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}"""
content = content.replace(old_label, new_label)

# 3. Fix usage 1 (restaurant)
old_usage_1 = """    final deliveryTimeStr = isRtl
        ? '${item.deliveryTimeMin}-${item.deliveryTimeMax} دقيقة'
        : '${item.deliveryTimeMin}-${item.deliveryTimeMax} min';

    context.push(
      RouteNames.restaurantDetailFor(item.id),
      extra: RestaurantDetailArgs(
        id: item.id,
        name: item.name,
        description: item.cuisineType,
        deliveryTime: deliveryTimeStr,"""
new_usage_1 = """    final deliveryTimeStr = isRtl
        ? '\\u200E${item.deliveryTimeMin} - ${item.deliveryTimeMax}\\u200E دقيقة'
        : '${item.deliveryTimeMin} - ${item.deliveryTimeMax} min';

    context.push(
      RouteNames.restaurantDetailFor(item.id),
      extra: RestaurantDetailArgs(
        id: item.id,
        name: item.name,
        description: item.cuisineType,
        deliveryTime: deliveryTimeStr,"""
content = content.replace(old_usage_1, new_usage_1)

# 4. Fix usage 2 (market)
old_usage_2 = """    final rating = _RatingBadge(rating: item.rating.toStringAsFixed(1));
    final deliveryTimeStr = isRtl
        ? '${item.deliveryTimeMin}-${item.deliveryTimeMax} دقيقة'
        : '${item.deliveryTimeMin}-${item.deliveryTimeMax} min';
    final time = _DeliveryTimeLabel(deliveryTime: deliveryTimeStr);"""
new_usage_2 = """    final rating = _RatingBadge(rating: item.rating.toStringAsFixed(1));
    final time = _DeliveryTimeLabel(minTime: item.deliveryTimeMin, maxTime: item.deliveryTimeMax);"""
content = content.replace(old_usage_2, new_usage_2)

with open('lib/features/profile/presentation/pages/favourites_screen.dart', 'w') as f:
    f.write(content)

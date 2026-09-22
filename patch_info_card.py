import re

with open('lib/features/restaurant/presentation/pages/restaurant_detail_screen.dart', 'r') as f:
    content = f.read()

# 1. Modify _RatingMetric to remove InkWell
rating_metric_old = """    return Expanded(
      child: InkWell(
        onTap: () => context.push(RouteNames.restaurantRateFor(restaurant.id)),
        borderRadius: const BorderRadius.all(AppRadius.sm),
        child: _InfoMetric(
          assetName: AppAssets.favoriteStarIcon,
          label: '${restaurant.rating.toStringAsFixed(1)} (${restaurant.ratingCount})',
          iconOnRight: isArabic,
        ),
      ),
    );"""
rating_metric_new = """    return Expanded(
      child: _InfoMetric(
        assetName: AppAssets.favoriteStarIcon,
        label: '${restaurant.rating.toStringAsFixed(1)} (${restaurant.ratingCount})',
        iconOnRight: isArabic,
      ),
    );"""
content = content.replace(rating_metric_old, rating_metric_new)

# 2. Add showModalBottomSheet import to the top if needed? We need restaurant_rate_screen.dart import.
if 'restaurant_rate_screen.dart' not in content:
    content = content.replace("import 'package:food_user_app/features/cart/presentation/widgets/cart_floating_banner.dart';", "import 'package:food_user_app/features/cart/presentation/widgets/cart_floating_banner.dart';\nimport 'package:food_user_app/features/restaurant/presentation/pages/restaurant_rate_screen.dart';")

# 3. Wrap Container in _RestaurantInfoCard with GestureDetector
container_old = """    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: 2,
          ),
        ],
      ),"""
container_new = """    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => FractionallySizedBox(
            heightFactor: 0.9,
            child: RestaurantRateScreen(restaurant: restaurant),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard(context),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.08),
              blurRadius: 2,
            ),
          ],
        ),"""
content = content.replace(container_old, container_new)

# 4. Make sure closing bracket matches for GestureDetector
end_of_info_card = """          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {"""
end_of_info_card_new = """          ),
        ],
      ),
    ),
    );
  }
}

class _StatusPill extends StatelessWidget {"""
content = content.replace(end_of_info_card, end_of_info_card_new)


with open('lib/features/restaurant/presentation/pages/restaurant_detail_screen.dart', 'w') as f:
    f.write(content)

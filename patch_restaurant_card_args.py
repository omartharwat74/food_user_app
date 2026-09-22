import re

with open('lib/features/restaurant/presentation/widgets/restaurant_card.dart', 'r') as f:
    content = f.read()

old_args = """              extra: RestaurantDetailArgs(
                id: restaurant.id,
                name: restaurant.name,
                description: restaurant.cuisineType,
                deliveryTime:
                    '${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} min',
                rating: restaurant.rating,
                logoAsset: restaurant.logoUrl,
                coverAsset: restaurant.coverUrl,
              ),"""

new_args = """              extra: RestaurantDetailArgs(
                id: restaurant.id,
                name: restaurant.name,
                description: restaurant.cuisineType,
                deliveryTime: isArabic
                    ? '\\u200E${restaurant.deliveryTimeMin} - ${restaurant.deliveryTimeMax}\\u200E دقيقة'
                    : '${restaurant.deliveryTimeMin} - ${restaurant.deliveryTimeMax} min',
                rating: restaurant.rating,
                logoAsset: restaurant.logoUrl,
                coverAsset: restaurant.coverUrl,
              ),"""

content = content.replace(old_args, new_args)

with open('lib/features/restaurant/presentation/widgets/restaurant_card.dart', 'w') as f:
    f.write(content)

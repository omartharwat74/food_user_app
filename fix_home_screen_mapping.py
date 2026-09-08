import re

with open('lib/features/home/presentation/pages/home_screen.dart', 'r') as f:
    content = f.read()

old_mapping = """                        final restaurant = Restaurant(
                          id: store.id.toString(),
                          name: store.name,
                          cuisineType: store.tags.isNotEmpty ? store.tags.first.name : '',
                          coverImageUrl: store.cover ?? '',
                          logoUrl: store.logo ?? '',
                          rating: store.ratingAvg ?? 0.0,
                          ratingCount: store.ratingCount ?? 0,
                          deliveryTimeMin: store.prepTimeFrom ?? 0,
                          deliveryTimeMax: store.prepTimeTo ?? 0,
                          deliveryFee: 0.0,
                          isFavorited: false,
                          isMajor: store.isMajor,
                        );"""

new_mapping = """                        final restaurant = Restaurant(
                          id: store.id.toString(),
                          name: store.name,
                          cuisineType: store.tags.isNotEmpty ? store.tags.first.name : '',
                          coverImageUrl: store.cover ?? '',
                          logoUrl: store.logo ?? '',
                          rating: store.ratingAvg ?? 0.0,
                          ratingCount: store.ratingCount ?? 0,
                          deliveryTimeMin: store.prepTimeFrom ?? 0,
                          deliveryTimeMax: store.prepTimeTo ?? 0,
                          deliveryFee: 0.0,
                          isFavorited: false,
                          isMajor: store.isMajor,
                          availability: store.availability,
                          tags: store.tags.map((t) => t.name).toList(),
                        );"""

content = content.replace(old_mapping, new_mapping)

with open('lib/features/home/presentation/pages/home_screen.dart', 'w') as f:
    f.write(content)

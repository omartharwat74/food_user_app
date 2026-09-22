import re
with open('lib/features/profile/presentation/pages/favourites_screen.dart', 'r') as f:
    content = f.read()

old_unused_1 = """    final rating = _RatingBadge(rating: item.rating.toStringAsFixed(1));
    final deliveryTimeStr = isRtl
        ? '\\u200E${item.deliveryTimeMin} - ${item.deliveryTimeMax}\\u200E دقيقة'
        : '${item.deliveryTimeMin} - ${item.deliveryTimeMax} min';
    final time = _DeliveryTimeLabel(minTime: item.deliveryTimeMin, maxTime: item.deliveryTimeMax);"""

new_unused_1 = """    final rating = _RatingBadge(rating: item.rating.toStringAsFixed(1));
    final time = _DeliveryTimeLabel(minTime: item.deliveryTimeMin, maxTime: item.deliveryTimeMax);"""
content = content.replace(old_unused_1, new_unused_1)

with open('lib/features/profile/presentation/pages/favourites_screen.dart', 'w') as f:
    f.write(content)

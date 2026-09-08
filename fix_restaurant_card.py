import re

with open('lib/features/restaurant/presentation/widgets/restaurant_card.dart', 'r') as f:
    content = f.read()

# 1. Availability Status next to Store Name
old_name_row = """                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            restaurant.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: AppTextStyles.body(context).copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _RatingBadge(
                          rating: restaurant.rating.toStringAsFixed(1),
                        ),
                      ],
                    ),"""

new_name_row = """                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  restaurant.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  style: AppTextStyles.body(context).copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              _AvailabilityBadge(availability: restaurant.availability),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        _RatingBadge(
                          rating: (restaurant.rating).toStringAsFixed(1),
                        ),
                      ],
                    ),"""

content = content.replace(old_name_row, new_name_row)

# 2. Add Tags Subtitle below the store name (before cuisineType or replacing it? "Add a subtitle Text widget below the store name for tags")
# Currently it has:
#                    const SizedBox(height: 8),
#                    Text(
#                      restaurant.cuisineType,
#                      ...
# Let's insert the tags before cuisineType or instead of it? The user said "Add a subtitle Text widget below the store name for tags".
old_cuisine = """                    const SizedBox(height: 8),
                    Text(
                      restaurant.cuisineType,"""

new_cuisine = """                    if (restaurant.tags.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        restaurant.tags.join(' ، '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: AppTextStyles.caption(context).copyWith(fontSize: 10, height: 1.25),
                      ),
                    ] else
                      const SizedBox.shrink(),
                    const SizedBox(height: 8),
                    Text(
                      restaurant.cuisineType,"""

content = content.replace(old_cuisine, new_cuisine)

# 3. Prep Time RTL Fix
old_time = """                          isArabic
                              ? '${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} دقيقة'
                              : '${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} min',"""

# The user explicitly states: It MUST be exactly formatted as: "${store.prepTimeFrom}-${store.prepTimeTo} دقيقة"
# We will use exactly: "${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} دقيقة"
new_time = """                          isArabic
                              ? "${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} دقيقة"
                              : "${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} min","""

content = content.replace(old_time, new_time)

# 4. Swap Rating Text and Icon in _RatingBadge
old_rating_badge = """      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: isRtl
            ? [text, const SizedBox(width: 2), icon]
            : [icon, const SizedBox(width: 2), text],
      ),"""

# "The text should be on the left, and the Star icon on the right to match Figma."
# In LTR, text on left, icon on right => [text, icon]
# In RTL, text on left, icon on right => [icon, text]
new_rating_badge = """      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: isRtl
            ? [icon, const SizedBox(width: 2), text]
            : [text, const SizedBox(width: 2), icon],
      ),"""

content = content.replace(old_rating_badge, new_rating_badge)

# Add _AvailabilityBadge class at the end
availability_badge_code = """

class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge({required this.availability});
  final String availability;

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;
    switch (availability.toLowerCase()) {
      case 'busy':
        color = Colors.orange;
        text = 'مشغول';
        break;
      case 'closed':
        color = Colors.red;
        text = 'مغلق';
        break;
      case 'open':
      default:
        color = Colors.green;
        text = 'متاح';
        break;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTextStyles.caption(context).copyWith(
            fontSize: 10,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
"""
content += availability_badge_code

with open('lib/features/restaurant/presentation/widgets/restaurant_card.dart', 'w') as f:
    f.write(content)


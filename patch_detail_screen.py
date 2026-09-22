import re

with open('lib/features/restaurant/presentation/pages/restaurant_detail_screen.dart', 'r') as f:
    content = f.read()

# 1. Update backButton
old_back_button = """    final backButton = IconButton(
      onPressed: () => context.pop(),
      visualDensity: VisualDensity.compact,
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: const Size(28, 28),
        padding: EdgeInsets.zero,
      ),
      icon: Transform.scale(
        scaleX: isArabic ? 1 : -1,
        child: const AppRasterImage.asset(
          AppAssets.restaurantInfoBackIcon,
          width: 20,
          height: 20,
        ),
      ),
    );"""

new_back_button = """    final backButton = Padding(
      padding: const EdgeInsets.all(4.0),
      child: Transform.scale(
        scaleX: isArabic ? 1 : -1,
        child: const AppRasterImage.asset(
          AppAssets.restaurantInfoBackIcon,
          width: 20,
          height: 20,
        ),
      ),
    );"""

content = content.replace(old_back_button, new_back_button)

# 2. Update onTap
old_on_tap = """    return GestureDetector(
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
      },"""

new_on_tap = """    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantRateScreen(restaurant: restaurant),
          ),
        );
      },"""

content = content.replace(old_on_tap, new_on_tap)

with open('lib/features/restaurant/presentation/pages/restaurant_detail_screen.dart', 'w') as f:
    f.write(content)

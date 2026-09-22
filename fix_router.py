import re

with open('lib/core/router/app_router.dart', 'r') as f:
    content = f.read()

route_regex = r"      GoRoute\(\s*path: RouteNames\.restaurantRate,\s*builder: \(c, s\) => RestaurantRateScreen\(\s*restaurantId: s\.pathParameters\['id'\] \?\? 'az-al-sham',\s*\),\s*\),"
content = re.sub(route_regex, "", content)

# Remove the import for restaurant_rate_screen.dart if we want? Let's leave it or remove it.
content = content.replace("import '../../features/restaurant/presentation/pages/restaurant_rate_screen.dart';", "")

with open('lib/core/router/app_router.dart', 'w') as f:
    f.write(content)

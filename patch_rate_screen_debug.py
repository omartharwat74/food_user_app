import re

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'r') as f:
    content = f.read()

debug_print_block = """    debugPrint('--- RESTAURANT DATA DUMP ---');
    debugPrint('ID: ${restaurant.id}');
    debugPrint('Name: ${restaurant.name}');
    debugPrint('Rating: ${restaurant.rating} (${restaurant.ratingCount} reviews)');
    debugPrint('Delivery Fee: ${restaurant.deliveryFee}');
    debugPrint('Delivery Time: ${restaurant.deliveryTimeMin} - ${restaurant.deliveryTimeMax}');
    debugPrint('Address: ${restaurant.address}');
    debugPrint('Reviews Count: ${restaurant.reviews.length}');
    debugPrint('Rating Distribution: ${restaurant.ratingDistribution}');
    debugPrint('-----------------------------');"""

content = content.replace("    final copy = _RateCopy.of(context);", f"{debug_print_block}\n\n    final copy = _RateCopy.of(context);")

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'w') as f:
    f.write(content)

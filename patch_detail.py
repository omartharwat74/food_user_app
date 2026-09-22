with open('lib/features/restaurant/presentation/pages/restaurant_detail_screen.dart', 'r') as f:
    content = f.read()

content = content.replace("bottomNavigationBar: const CartFloatingBanner(),", "bottomNavigationBar: CartFloatingBanner(currentStoreId: restaurant.id),")

with open('lib/features/restaurant/presentation/pages/restaurant_detail_screen.dart', 'w') as f:
    f.write(content)

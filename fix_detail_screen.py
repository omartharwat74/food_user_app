with open('lib/features/restaurant/presentation/pages/restaurant_detail_screen.dart', 'r') as f:
    content = f.read()

# Add import
if 'cart_floating_banner.dart' not in content:
    content = content.replace("import 'package:food_user_app/features/restaurant/presentation/widgets/menu_item_tile.dart';", "import 'package:food_user_app/features/restaurant/presentation/widgets/menu_item_tile.dart';\nimport 'package:food_user_app/features/cart/presentation/widgets/cart_floating_banner.dart';")

# Add bottomNavigationBar
content = content.replace("              return Scaffold(\n                backgroundColor: AppColors.scaffoldBackground(context),\n                body: CustomScrollView(", "              return Scaffold(\n                backgroundColor: AppColors.scaffoldBackground(context),\n                bottomNavigationBar: const CartFloatingBanner(),\n                body: CustomScrollView(")

with open('lib/features/restaurant/presentation/pages/restaurant_detail_screen.dart', 'w') as f:
    f.write(content)

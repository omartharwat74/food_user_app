import re

with open('lib/features/cart/presentation/widgets/cart_floating_banner.dart', 'r') as f:
    content = f.read()

# Add currentStoreId to constructor
content = content.replace('const CartFloatingBanner({super.key});', 'const CartFloatingBanner({required this.currentStoreId, super.key});\n\n  final String currentStoreId;')

# Update condition
content = content.replace('if (cart != null && cart.items.isNotEmpty) {', 'if (cart != null && cart.items.isNotEmpty && cart.restaurantId == currentStoreId) {')

# Fix RTL layout: reverse the order of children in Row
old_row = """                      Text(
                        'اطلع على السلة',
                        style: AppTextStyles.body(context).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          totalItems.toString(),
                          style: AppTextStyles.body(context).copyWith(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),"""

new_row = """                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          totalItems.toString(),
                          style: AppTextStyles.body(context).copyWith(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'اطلع على السلة',
                        style: AppTextStyles.body(context).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),"""
content = content.replace(old_row, new_row)

# Fix Navigation
# Need to import main_layout.dart
if 'main_layout.dart' not in content:
    content = content.replace("import 'package:food_user_app/core/router/route_names.dart';", "import 'package:food_user_app/core/router/route_names.dart';\nimport 'package:food_user_app/features/main/presentation/pages/main_layout.dart';")

content = content.replace("onTap: () => context.push(RouteNames.cart),", """onTap: () {
                  context.go(RouteNames.home);
                  MainLayout.globalKey.currentState?.changeIndex(1);
                },""")

with open('lib/features/cart/presentation/widgets/cart_floating_banner.dart', 'w') as f:
    f.write(content)

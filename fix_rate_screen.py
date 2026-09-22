import re

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'r') as f:
    content = f.read()

# Add necessary imports
imports = """
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/di/injection_container.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/restaurant_detail_cubit.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/restaurant_detail_state.dart';
import 'package:food_user_app/features/restaurant/domain/entities/restaurant.dart';
import 'package:food_user_app/features/restaurant/domain/entities/review.dart';
"""
content = re.sub(r"import 'package:food_user_app/features/restaurant/data/mock/restaurant_mock_data.dart';", imports, content)

# Modify RestaurantRateScreen to wrap in BlocProvider
content = re.sub(
    r"class RestaurantRateScreen extends StatelessWidget \{[\s\S]*?final String restaurantId;",
    """class RestaurantRateScreen extends StatelessWidget {
  const RestaurantRateScreen({this.restaurantId = 'az-al-sham', super.key});

  final String restaurantId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RestaurantDetailCubit>()..getRestaurantDetail(restaurantId),
      child: _RestaurantRateView(restaurantId: restaurantId),
    );
  }
}

class _RestaurantRateView extends StatelessWidget {
  const _RestaurantRateView({required this.restaurantId});
  final String restaurantId;
""",
    content
)

# Modify the build method of _RestaurantRateView
build_method_pattern = r"  @override\n  Widget build\(BuildContext context\) \{\n    final copy = _RateCopy\.of\(context\);\n    final locale = Localizations\.localeOf\(context\);\n    final restaurant = mockRestaurant;\n\n    return Scaffold\("
new_build = """  @override
  Widget build(BuildContext context) {
    final copy = _RateCopy.of(context);
    final locale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: BlocBuilder<RestaurantDetailCubit, RestaurantDetailState>(
        builder: (context, state) {
          if (state is RestaurantDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is RestaurantDetailError) {
            return Center(child: Text(state.message));
          }
          if (state is RestaurantDetailLoaded) {
            final restaurant = state.restaurant;
            return SafeArea(
              bottom: false,
              child: CustomScrollView(
"""
content = content.replace("  @override\n  Widget build(BuildContext context) {\n    final copy = _RateCopy.of(context);\n    final locale = Localizations.localeOf(context);\n    final restaurant = mockRestaurant;\n\n    return Scaffold(\n      backgroundColor: AppColors.scaffoldBackground(context),\n      body: SafeArea(\n        bottom: false,\n        child: CustomScrollView(", new_build)

# Add closing bracket for the BlocBuilder
content = content.replace("            ),\n          ],\n        ),\n      ),\n    );\n  }\n}\n\nclass _RateHeader extends StatelessWidget", "            ),\n          ],\n        ),\n      );\n          }\n          return const SizedBox.shrink();\n        },\n      ),\n    );\n  }\n}\n\nclass _RateHeader extends StatelessWidget")

# Update MockReview to Review
content = content.replace("MockReview", "Review")
content = content.replace("MockRestaurant", "Restaurant")

# Remove review.name(locale) and review.comment(locale) calls
content = content.replace("review.name(locale)", "review.userName")
content = content.replace("review.comment(locale)", "review.comment")

# Fix date (MockReview has review.date, Review has review.createdAt)
content = content.replace("review.date,", "review.createdAt,")

# Update MockRestaurant methods:
# restaurant.deliveryFee(locale) -> "\$${restaurant.deliveryFee.toFormattedPrice()} رس"
# minimumOrder -> "\$${restaurant.deliveryFee.toFormattedPrice()} رس"
# deliveryTime -> "${restaurant.deliveryTimeMin} - ${restaurant.deliveryTimeMax} دقيقة"
# address -> restaurant.address
# previousOrders -> "-"
content = content.replace("restaurant.deliveryFee(locale)", "isArabic ? '${restaurant.deliveryFee.toInt()} رس' : '${restaurant.deliveryFee.toInt()} SAR'")
content = content.replace("restaurant.minimumOrder(locale)", "isArabic ? '0 رس' : '0 SAR'") # Assuming 0 for now as we don't have minimum order
content = content.replace("restaurant.deliveryTime(locale)", "isArabic ? '${restaurant.deliveryTimeMin} - ${restaurant.deliveryTimeMax} دقيقة' : '${restaurant.deliveryTimeMin} - ${restaurant.deliveryTimeMax} min'")
content = content.replace("restaurant.address(locale)", "restaurant.address")
content = content.replace("restaurant.previousOrders(locale)", "'-'")

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'w') as f:
    f.write(content)

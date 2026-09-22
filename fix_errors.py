with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'r') as f:
    content = f.read()

# 1. getIt -> sl
content = content.replace("getIt<RestaurantDetailCubit>()", "sl<RestaurantDetailCubit>()")

# 2. Fix BlocBuilder with Freezed
freezed_builder = """      body: BlocBuilder<RestaurantDetailCubit, RestaurantDetailState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(child: Text(message)),
            loaded: (restaurant, _, __, ___) {
              return SafeArea(
                bottom: false,
                child: CustomScrollView(
"""
content = content.replace("""      body: BlocBuilder<RestaurantDetailCubit, RestaurantDetailState>(
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
              child: CustomScrollView(""", freezed_builder)

# Replace the closing logic
content = content.replace("""                ],
              ),
            ),
          ],
        ),
      );
          }
          return const SizedBox.shrink();
        },""", """                ],
              ),
            ),
          ],
        ),
      );
            },
            orElse: () => const SizedBox.shrink(),
          );
        },""")

# 3. isArabic undefined in _RestaurantFacts / _FactRow / _PaymentRow.
# In _FactRow:
# It already has `final isArabic = Directionality.of(context) == TextDirection.rtl;`
# But where is it undefined? Let's fix lines 450, 454, 457.
# It seems my string replacements inserted `isArabic` inside `_RestaurantFacts` or somewhere where it's not defined!
content = content.replace("isArabic ? '${restaurant.deliveryFee.toInt()} رس' : '${restaurant.deliveryFee.toInt()} SAR'", "Localizations.localeOf(context).languageCode == 'ar' ? '${restaurant.deliveryFee.toFormattedPrice()} رس' : '${restaurant.deliveryFee.toFormattedPrice()} SAR'")
content = content.replace("isArabic ? '0 رس' : '0 SAR'", "Localizations.localeOf(context).languageCode == 'ar' ? '0 رس' : '0 SAR'")
content = content.replace("isArabic ? '${restaurant.deliveryTimeMin} - ${restaurant.deliveryTimeMax} دقيقة' : '${restaurant.deliveryTimeMin} - ${restaurant.deliveryTimeMax} min'", "Localizations.localeOf(context).languageCode == 'ar' ? '${restaurant.deliveryTimeMin} - ${restaurant.deliveryTimeMax} دقيقة' : '${restaurant.deliveryTimeMin} - ${restaurant.deliveryTimeMax} min'")
# Note: In earlier script, I replaced `restaurant.deliveryFee.toInt()` but the original was `.toFormattedPrice()`. I'll just use `toFormattedPrice()` here directly.

# 4. _Stars selectedCount type is int? but rating is double?
# "The argument type 'double' can't be assigned to the parameter type 'int?'."
# `_Stars(size: 12, count: 5, selectedCount: review.rating)` -> review.rating is double!
content = content.replace("selectedCount: review.rating", "selectedCount: review.rating.toInt()")

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'w') as f:
    f.write(content)

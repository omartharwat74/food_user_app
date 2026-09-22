import re

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'r') as f:
    content = f.read()

# Replace the entire _RestaurantRateView block and _RateHeader (to fix name(locale))
new_view = """class _RestaurantRateView extends StatelessWidget {
  const _RestaurantRateView({required this.restaurantId});
  final String restaurantId;

  @override
  Widget build(BuildContext context) {
    final copy = _RateCopy.of(context);
    final locale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: BlocBuilder<RestaurantDetailCubit, RestaurantDetailState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(child: Text(message)),
            loaded: (restaurant, menuCategories, branches, offers) {
              return SafeArea(
                bottom: false,
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        AppSpacing.md,
                        18,
                        AppSpacing.md,
                        28,
                      ),
                      sliver: SliverList.list(
                        children: [
                          _RateHeader(title: restaurant.name),
                          const SizedBox(height: 24),
                          _RatingSummary(
                            rating: restaurant.rating,
                            ratingCount: restaurant.ratingCount,
                            ratingDistribution: restaurant.ratingDistribution,
                            copy: copy,
                          ),
                          const SizedBox(height: 18),
                          _SectionHeader(title: copy.customerReviews),
                          const SizedBox(height: 12),
                          ...restaurant.reviews.map(
                            (review) => _ReviewTile(review: review, locale: locale),
                          ),
                          if (restaurant.reviewsHasMore)
                            Center(
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  AppLocalizations.of(context)!.seeAll,
                                  style: AppTextStyles.body(context).copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 18),
                          _SectionHeader(title: copy.moreDetails),
                          const SizedBox(height: 14),
                          _RestaurantFacts(
                            restaurant: restaurant,
                            locale: locale,
                            copy: copy,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}"""

content = re.sub(r"class _RestaurantRateView extends StatelessWidget \{[\s\S]*?class _RateHeader extends StatelessWidget", new_view + "\n\nclass _RateHeader extends StatelessWidget", content)

# Fix _RatingSummary ratingCount type: String -> int
content = content.replace("final String ratingCount;", "final int ratingCount;")

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'w') as f:
    f.write(content)

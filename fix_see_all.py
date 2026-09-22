with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'r') as f:
    content = f.read()

see_all_widget = """                  ...restaurant.reviews.map(
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
                  const SizedBox(height: 24),
                  _SectionHeader(title: copy.moreDetails),
                  const SizedBox(height: 12),
                  _RestaurantFacts(
                    restaurant: restaurant,
                    locale: locale,
                    copy: copy,
                  ),
"""
# Search for where reviews are mapped
content = content.replace("                  ...restaurant.reviews.map(\n                    (review) => _ReviewTile(review: review, locale: locale),\n                  ),\n                ],\n              ),\n            ),\n          ],\n        ),\n      );\n          }\n          return const SizedBox.shrink();", """                  ...restaurant.reviews.map(
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
                  const SizedBox(height: 24),
                  _SectionHeader(title: copy.moreDetails),
                  const SizedBox(height: 12),
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
          }
          return const SizedBox.shrink();""")

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'w') as f:
    f.write(content)

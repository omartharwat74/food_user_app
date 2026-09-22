import re

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'r') as f:
    content = f.read()

old_reviews = """                  const SizedBox(height: 18),
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
                  const SizedBox(height: 18),"""

new_reviews = """                  if (restaurant.reviews.isNotEmpty) ...[
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
                  ],"""

content = content.replace(old_reviews, new_reviews)

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'w') as f:
    f.write(content)

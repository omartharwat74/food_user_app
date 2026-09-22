import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/app_radius.dart';
import 'package:food_user_app/core/theme/app_spacing.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/app_media.dart';

import 'package:food_user_app/core/utils/price_extension.dart';
import 'package:food_user_app/features/restaurant/domain/entities/restaurant.dart';
import 'package:food_user_app/features/restaurant/domain/entities/review.dart';

import 'package:food_user_app/core/widgets/app_directional_icons.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

class RestaurantRateScreen extends StatelessWidget {
  const RestaurantRateScreen({required this.restaurant, super.key});
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    debugPrint('--- RESTAURANT DATA DUMP ---');
    debugPrint('ID: ${restaurant.id}');
    debugPrint('Name: ${restaurant.name}');
    debugPrint(
      'Rating: ${restaurant.rating} (${restaurant.ratingCount} reviews)',
    );
    debugPrint('Delivery Fee: ${restaurant.deliveryFee}');
    debugPrint(
      'Delivery Time: ${restaurant.deliveryTimeMin} - ${restaurant.deliveryTimeMax}',
    );
    debugPrint('Address: ${restaurant.address}');
    debugPrint('Reviews Count: ${restaurant.reviews.length}');
    debugPrint('Rating Distribution: ${restaurant.ratingDistribution}');
    debugPrint('-----------------------------');

    final copy = _RateCopy.of(context);
    final locale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: SafeArea(
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
                  if (restaurant.reviews.isNotEmpty) ...[
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
                  ],
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
      ),
    );
  }
}

class _RateHeader extends StatelessWidget {
  const _RateHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Align(
      alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.ltr,
        children: isArabic
            ? [
                Text(
                  title,
                  style: AppTextStyles.heading4(
                    context,
                  ).copyWith(fontSize: 16, height: 1.4),
                ),
                const SizedBox(width: AppSpacing.xs),
                _HeaderBackButton(
                  icon: AppDirectionalIcons.backChevron(context),
                  onPressed: () => context.pop(),
                ),
              ]
            : [
                _HeaderBackButton(
                  icon: AppDirectionalIcons.backChevron(context),
                  onPressed: () => context.pop(),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  title,
                  style: AppTextStyles.heading4(
                    context,
                  ).copyWith(fontSize: 16, height: 1.4),
                ),
              ],
      ),
    );
  }
}

class _HeaderBackButton extends StatelessWidget {
  const _HeaderBackButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: const Size(28, 28),
        padding: EdgeInsets.zero,
      ),
      icon: Icon(icon, size: 28),
    );
  }
}

class _RatingSummary extends StatelessWidget {
  const _RatingSummary({
    required this.rating,
    required this.ratingCount,
    required this.copy,
    required this.ratingDistribution,
  });

  final double rating;
  final int ratingCount;
  final _RateCopy copy;
  final Map<String, dynamic> ratingDistribution;

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final scoreSummary = SizedBox(
      width: 152,
      child: Column(
        children: [
          Text(
            rating.toStringAsFixed(1),
            style: AppTextStyles.heading1(
              context,
            ).copyWith(fontSize: 20, height: 1.4),
          ),
          const SizedBox(height: AppSpacing.sm),
          _Stars(size: 24, selectedCount: rating.round()),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '($ratingCount ${copy.ratingsLabel})',
            style: AppTextStyles.caption(
              context,
            ).copyWith(fontSize: 12, height: 1.3),
          ),
        ],
      ),
    );
    final divider = Container(
      width: 1,
      height: 40,
      color: AppColors.border(context),
    );
    final bars = _RatingBars(
      isArabic: isArabic,
      ratingCount: ratingCount,
      ratingDistribution: ratingDistribution,
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground(context),
        borderRadius: const BorderRadius.all(AppRadius.md),
        border: Border.all(color: AppColors.border(context), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.ltr,
        children: isArabic
            ? [scoreSummary, divider, bars]
            : [bars, divider, scoreSummary],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.size, this.count = 5, this.selectedCount});

  final double size;
  final int count;
  final int? selectedCount;

  @override
  Widget build(BuildContext context) {
    final selected = selectedCount ?? count;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        count,
        (index) => Icon(
          Icons.star_rounded,
          color: index < selected
              ? AppColors.ratingStar
              : AppColors.paragraph(context).withValues(alpha: 0.35),
          size: size,
        ),
      ),
    );
  }
}

class _RatingBars extends StatelessWidget {
  const _RatingBars({
    required this.isArabic,
    required this.ratingCount,
    required this.ratingDistribution,
  });

  final bool isArabic;
  final int ratingCount;
  final Map<String, dynamic> ratingDistribution;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(5, (index) {
        final score = 5 - index;
        final count =
            (ratingDistribution[score.toString()] as num?)?.toInt() ?? 0;
        final value = ratingCount > 0 ? (count / ratingCount) : 0.0;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            textDirection: TextDirection.ltr,
            children: isArabic
                ? [
                    _RatingBar(value: value),
                    const SizedBox(width: 5),
                    _RatingScore(score: score),
                  ]
                : [
                    _RatingScore(score: score),
                    const SizedBox(width: 5),
                    _RatingBar(value: value),
                  ],
          ),
        );
      }),
    );
  }
}

class _RatingBar extends StatelessWidget {
  const _RatingBar({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 122,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(AppRadius.full),
        child: LinearProgressIndicator(
          minHeight: 3,
          value: value,
          backgroundColor: AppColors.mutedControl,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _RatingScore extends StatelessWidget {
  const _RatingScore({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$score',
      style: AppTextStyles.caption(
        context,
      ).copyWith(fontSize: 12, color: AppColors.onSurface(context)),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: AppTextStyles.heading4(
          context,
        ).copyWith(fontSize: 15, height: 1.4),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review, required this.locale});

  final Review review;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final isArabic = locale.languageCode == 'ar';

    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border(context), width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textDirection: TextDirection.ltr,
            children: isArabic
                ? [
                    Text(
                      review.createdAt,
                      style: AppTextStyles.caption(
                        context,
                      ).copyWith(fontSize: 10, height: 1.25),
                    ),
                    Text(
                      review.userName,
                      style: AppTextStyles.body(
                        context,
                      ).copyWith(fontSize: 12, height: 1.3),
                    ),
                  ]
                : [
                    Text(
                      review.userName,
                      style: AppTextStyles.body(
                        context,
                      ).copyWith(fontSize: 12, height: 1.3),
                    ),
                    Text(
                      review.createdAt,
                      style: AppTextStyles.caption(
                        context,
                      ).copyWith(fontSize: 10, height: 1.25),
                    ),
                  ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
            child: _Stars(
              size: 12,
              count: 5,
              selectedCount: review.rating.toInt(),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            review.comment,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            style: AppTextStyles.caption(
              context,
            ).copyWith(fontSize: 12, height: 1.3),
          ),
        ],
      ),
    );
  }
}

class _RestaurantFacts extends StatelessWidget {
  const _RestaurantFacts({
    required this.restaurant,
    required this.locale,
    required this.copy,
  });

  final Restaurant restaurant;
  final Locale locale;
  final _RateCopy copy;

  @override
  Widget build(BuildContext context) {
    final isArabic = locale.languageCode == 'ar';
    final facts = [
      (
        copy.deliveryPrice,
        isArabic
            ? '${restaurant.deliveryFee.toFormattedPrice()} ج.م'
            : 'EGP ${restaurant.deliveryFee.toFormattedPrice()}',
      ),
      (copy.minimumOrder, isArabic ? '0 ج.م' : 'EGP 0'),
      (
        copy.deliveryTime,
        isArabic
            ? '${restaurant.deliveryTimeMin} - ${restaurant.deliveryTimeMax} دقيقة'
            : '${restaurant.deliveryTimeMin} - ${restaurant.deliveryTimeMax} min',
      ),
      (copy.address, restaurant.address),
      (copy.previousOrders, '-'),
    ];

    return Column(
      children: [
        for (final fact in facts) _FactRow(label: fact.$1, value: fact.$2),
        _PaymentRow(label: copy.paymentMethod),
      ],
    );
  }
}

class _FactRow extends StatelessWidget {
  const _FactRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final valueText = Flexible(
      child: Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: isArabic ? TextAlign.start : TextAlign.end,
        style: AppTextStyles.caption(context).copyWith(
          color: AppColors.onSurface(context),
          fontSize: 12,
          height: 1.3,
        ),
      ),
    );
    final labelText = Text(
      label,
      style: AppTextStyles.body(context).copyWith(
        color: AppColors.paragraph(context),
        fontSize: 12,
        height: 1.3,
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border(context), width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.ltr,
        children: isArabic
            ? [valueText, const SizedBox(width: 12), labelText]
            : [labelText, const SizedBox(width: 12), valueText],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    const icons = Row(
      textDirection: TextDirection.ltr,
      children: [
        AppRasterImage.asset(
          AppAssets.restaurantPaymentGreenIcon,
          width: 16,
          height: 16,
        ),
        SizedBox(width: 12),
        AppRasterImage.asset(
          AppAssets.restaurantPaymentRedIcon,
          width: 16,
          height: 16,
        ),
        SizedBox(width: 12),
        AppRasterImage.asset(
          AppAssets.restaurantPaymentYellowIcon,
          width: 16,
          height: 16,
        ),
      ],
    );
    final labelText = Text(
      label,
      style: AppTextStyles.body(context).copyWith(
        color: AppColors.paragraph(context),
        fontSize: 12,
        height: 1.3,
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.ltr,
        children: isArabic ? [icons, labelText] : [labelText, icons],
      ),
    );
  }
}

class _RateCopy {
  const _RateCopy({
    required this.customerReviews,
    required this.ratingsLabel,
    required this.moreDetails,
    required this.deliveryPrice,
    required this.minimumOrder,
    required this.deliveryTime,
    required this.address,
    required this.previousOrders,
    required this.paymentMethod,
  });

  final String customerReviews;
  final String ratingsLabel;
  final String moreDetails;
  final String deliveryPrice;
  final String minimumOrder;
  final String deliveryTime;
  final String address;
  final String previousOrders;
  final String paymentMethod;

  static _RateCopy of(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _RateCopy(
      customerReviews: l10n.restaurantRateCustomerReviews,
      ratingsLabel: l10n.restaurantRateRatingsLabel,
      moreDetails: l10n.restaurantRateMoreDetails,
      deliveryPrice: l10n.restaurantRateDeliveryPrice,
      minimumOrder: l10n.restaurantRateMinimumOrder,
      deliveryTime: l10n.restaurantRateDeliveryTime,
      address: l10n.restaurantRateAddress,
      previousOrders: l10n.restaurantRatePreviousOrders,
      paymentMethod: l10n.restaurantRatePaymentMethod,
    );
  }
}

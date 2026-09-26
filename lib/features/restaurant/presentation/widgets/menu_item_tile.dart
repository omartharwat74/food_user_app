import 'package:food_user_app/core/theme/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:food_user_app/core/utils/price_extension.dart';
import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_item.dart';
import 'package:food_user_app/core/di/injection_container.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/product_detail_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/product/presentation/pages/product_details_screen.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

class MenuItemTile extends StatelessWidget {
  const MenuItemTile({super.key, required this.item});

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => _openProductDetails(context, item, locale),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border(context), width: 0.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE (Fixed Size)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  item.imageUrl.isNotEmpty
                      ? Image.network(
                          item.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          AppAssets.restaurantMenuBurgerFries1,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                  _buildDiscountBadge(context, item, locale),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // TEXT CONTENT (Must be Expanded to prevent overflow)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.onSurface(context),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Expo Arabic',
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (item.originalPrice > item.price)
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${item.price.toFormattedPrice()} ${l10n.currency}',
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: AppTextStyles.body(context).copyWith(
                              fontSize: 12,
                              height: 1.3,
                              color: AppColors.onSurface(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${item.originalPrice.toFormattedPrice()} ${l10n.currency}',
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: AppTextStyles.body(context).copyWith(
                              fontSize: 10,
                              height: 1.3,
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.paragraph(
                                context,
                              ).withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      '${item.price.toFormattedPrice()} ${l10n.currency}',
                      textAlign: TextAlign.start,
                      style: AppTextStyles.body(context).copyWith(
                        fontSize: 12,
                        height: 1.3,
                        color: AppColors.onSurface(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // ARROW ICON
            Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.onSurface(context),
                textDirection: Directionality.of(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountBadge(
    BuildContext context,
    MenuItem item,
    Locale locale,
  ) {
    if (item.discountValue <= 0) {
      return const SizedBox.shrink();
    }

    final isArabic = locale.languageCode == 'ar';
    String badgeText;

    if (item.discountType == 'percentage') {
      badgeText = isArabic
          ? (AppLocalizations.of(context)!.discount +
                ' ' +
                item.discountValue.toFormattedPrice() +
                '%')
          : '${item.discountValue.toFormattedPrice()}% OFF';
    } else {
      badgeText = isArabic
          ? (AppLocalizations.of(context)!.discount +
                ' ' +
                AppLocalizations.of(
                  context,
                )!.priceWithCurrency(item.discountValue.toFormattedPrice()))
          : '${item.discountValue.toFormattedPrice()} EGP OFF';
    }

    return Positioned.directional(
      textDirection: Directionality.of(context),
      top: 4,
      start: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: const BoxDecoration(
          color: Color(0xFF0C9D61),
          borderRadius: BorderRadius.all(AppRadius.sm),
        ),
        child: Text(
          badgeText,
          style: AppTextStyles.caption(context).copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w500,
            fontSize: 8,
          ),
        ),
      ),
    );
  }

  void _openProductDetails(BuildContext context, MenuItem item, Locale locale) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => BlocProvider<ProductDetailCubit>(
        create: (context) =>
            sl<ProductDetailCubit>()..fetchProductDetails(item.id),
        child: ProductDetailsScreen(item: item),
      ),
    );
  }
}

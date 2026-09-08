import 'package:food_user_app/core/theme/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/app_media.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_item.dart';
import 'package:food_user_app/core/di/injection_container.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/product_detail_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/product/presentation/pages/product_details_screen.dart';

class MenuItemTile extends StatelessWidget {
  const MenuItemTile({super.key, required this.item});

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';

    return Material(
      color: AppColors.surfaceCard(context),
      borderRadius: const BorderRadius.all(AppRadius.md),
      child: InkWell(
        borderRadius: const BorderRadius.all(AppRadius.md),
        onTap: () => _openProductDetails(context, item, locale),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(AppRadius.md),
            border: Border.all(color: AppColors.border(context), width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 100,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: AppRadius.md,
                        ),
                        child: item.imageUrl.isNotEmpty
                            ? AppNetworkImage(item.imageUrl, fit: BoxFit.cover)
                            : const AppRasterImage.asset(
                                AppAssets.restaurantMenuBurgerFries1,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    _buildDiscountBadge(context, item, locale),
                    Positioned(
                      left: isArabic ? 8 : null,
                      right: isArabic ? null : 8,
                      bottom: 8,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard(context),
                          borderRadius: const BorderRadius.all(AppRadius.sm),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withValues(alpha: 0.08),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: AppColors.onSurface(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body(
                          context,
                        ).copyWith(fontSize: 12, height: 1.25, fontWeight: FontWeight.w400),
                      ),
                      if (item.originalPrice > item.price)
                        Row(
                          children: [
                            Text(
                              _formatPrice(item.price, locale),
                              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                              style: AppTextStyles.body(context).copyWith(
                                fontSize: 12,
                                height: 1.3,
                                color: AppColors.onSurface(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatPrice(item.originalPrice, locale),
                              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                              style: AppTextStyles.body(context).copyWith(
                                fontSize: 10,
                                height: 1.3,
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.paragraph(context).withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          _formatPrice(item.price, locale),
                          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiscountBadge(BuildContext context, MenuItem item, Locale locale) {
    if (item.discountValue <= 0) {
      return const SizedBox.shrink();
    }
    
    final isArabic = locale.languageCode == 'ar';
    String badgeText;
    
    if (item.discountType == 'percentage') {
      badgeText = isArabic 
          ? 'خصم ${item.discountValue.toStringAsFixed(0)}%'
          : '${item.discountValue.toStringAsFixed(0)}% OFF';
    } else {
      badgeText = isArabic
          ? 'خصم ${item.discountValue.toStringAsFixed(0)} ج.م'
          : '${item.discountValue.toStringAsFixed(0)} EGP OFF';
    }

    return Positioned(
      top: 8,
      left: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: const BoxDecoration(
          color: Color(0xFF0C9D61),
          borderRadius: BorderRadius.all(AppRadius.sm),
        ),
        child: Text(
          badgeText,
          style: AppTextStyles.caption(context).copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w500,
            fontSize: 10,
          ),
        ),
      ),
    );
  }

  String _formatPrice(double price, Locale locale) {
    final isArabic = locale.languageCode == 'ar';
    return isArabic
        ? '${price.toStringAsFixed(0)} ج.م'
        : 'EGP ${price.toStringAsFixed(0)}';
  }

  void _openProductDetails(BuildContext context, MenuItem item, Locale locale) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => BlocProvider<ProductDetailCubit>(
        create: (context) => sl<ProductDetailCubit>()..fetchProductDetails(item.id),
        child: ProductDetailsScreen(item: item), // We will update ProductDetailsScreen to accept MenuItem
      ),
    );
  }
}

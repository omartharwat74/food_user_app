import 'package:flutter/material.dart';
import 'package:food_user_app/core/utils/price_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/di/injection_container.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/product_detail_cubit.dart';
import 'package:food_user_app/features/product/presentation/pages/product_details_screen.dart';
import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_item.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

/// Grid product card — Figma node 6749:11541 / 8145:10236.
/// Adaptive: RTL/LTR via Directionality, Dark/Light via AppColors.
class ProductCard extends StatelessWidget {
  final MenuItem item;
  final bool isGridMode;

  const ProductCard({super.key, required this.item, this.isGridMode = false});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasOffer = item.discountValue > 0;
    final hasOldPrice = item.originalPrice > item.price;

    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (ctx) => BlocProvider<ProductDetailCubit>(
          create: (_) => sl<ProductDetailCubit>()..fetchProductDetails(item.id),
          child: ProductDetailsScreen(item: item),
        ),
      ),
      child: Container(
        // Figma: w=165.5, r=12, fill=#FFFFFF, stroke=#E5E5E5 0.5px
        width: 165.50,
        decoration: ShapeDecoration(
          color: AppColors.surfaceCard(context),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.border(context), width: 0.50),
            borderRadius: BorderRadius.circular(12),
          ),
          shadows: const [
            // Figma Shadow: 0px 0px 4px rgba(44,43,43,0.08)
            BoxShadow(color: Color(0x142C2A2A), blurRadius: 4),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image section (h=100) ─────────────────────────────────
            // Figma: borderRadius 12 12 0 0
            Container(
              width: double.infinity,
              height: 100,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                image: DecorationImage(
                  image: item.imageUrl.isNotEmpty
                      ? NetworkImage(item.imageUrl)
                      : const AssetImage(AppAssets.productBurgerCombo)
                          as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Arrow icon — trailing (end: 8), bottom: 8
                  Positioned.directional(
                    textDirection: Directionality.of(context),
                    end: 8,
                    bottom: 8,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: ShapeDecoration(
                        color: AppColors.surfaceCard(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        shadows: const [
                          BoxShadow(color: Color(0x142C2A2A), blurRadius: 4),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          // auto-flips < in RTL, > in LTR
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: AppColors.onSurface(context),
                          textDirection: Directionality.of(context),
                        ),
                      ),
                    ),
                  ),

                  // Discount badge — trailing (end: 8), top: 8
                  if (hasOffer)
                    Positioned.directional(
                      textDirection: Directionality.of(context),
                      end: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        decoration: const BoxDecoration(
                          color: Color(0xFF0C9D61),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        child: Text(
                          '${l10n.discount} ${item.discountValue.toFormattedPrice()}%',
                          style: const TextStyle(
                            // Figma Mobile/10m white w500 10px
                            color: Colors.white,
                            fontFamily: 'Expo Arabic',
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Text section ─────────────────────────────────────────
            // Figma: padding=12, gap=8
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Product name — Figma Mobile/Body Rmd 12px w400 #1B1B1B
                      Flexible(
                        child: Text(
                          item.name,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Expo Arabic',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                            color: AppColors.onSurface(context),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Price row — Figma: row, gap=8
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Current price — Figma Mobile/12m w500 #1B1B1B
                          Flexible(
                            child: Text(
                              '${item.price.toFormattedPrice()} ${l10n.currency}',
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: 'Expo Arabic',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                height: 1.3,
                                color: AppColors.onSurface(context),
                              ),
                            ),
                          ),
                          if (hasOldPrice) ...[
                            const SizedBox(width: 8),
                            // Strikethrough old price — Figma: #B9B9B9, lineThrough
                            Flexible(
                              child: Text(
                                '${item.originalPrice.toFormattedPrice()} ${l10n.currency}',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontFamily: 'Expo Arabic',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 1.3,
                                  color: Color(0xFFB9B9B9),
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Color(0xFFB9B9B9),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

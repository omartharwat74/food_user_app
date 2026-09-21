import 'package:flutter/material.dart';
import 'package:food_user_app/core/utils/price_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/di/injection_container.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/product_detail_cubit.dart';
import 'package:food_user_app/features/product/presentation/pages/product_details_screen.dart';
import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/widgets/app_media.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_item.dart';

/// Figma ref: node #8145:10237 "Property 1=Variant2"
/// Total height: 164px = 100px (image) + 64px (content: 12 padding + text + 8 gap + text + 12 padding)
/// Card width: contextual (165.5px in grid, 134px in horizontal list)
class ProductCard extends StatelessWidget {
  final MenuItem item;
  final bool isGridMode;

  const ProductCard({super.key, required this.item, this.isGridMode = false});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (context) => BlocProvider<ProductDetailCubit>(
              create: (context) => sl<ProductDetailCubit>()..fetchProductDetails(item.id),
              child: ProductDetailsScreen(item: item),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          // Total height is managed by parent (164px); no explicit height here.
          decoration: BoxDecoration(
            color: Colors.white, // Figma: fill_658ab2fa = #FFFFFF
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE5E5E5), // Figma: fill_491b2e25 = #E5E5E5
              width: 0.5,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14002B2B), // Figma Shadow: rgba(44,43,43,0.08)
                blurRadius: 4,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Image area: 100px fixed height ───────────────────────────
              SizedBox(
                height: 100, // Figma: #8145:10238 dimensions.height = 100
                child: Stack(
                  children: [
                    // Full-width product image
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: item.imageUrl.isNotEmpty
                            ? AppNetworkImage(item.imageUrl, fit: BoxFit.cover)
                            : AppRasterImage.asset(
                                AppAssets.productBurgerCombo,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    // ── '+' button ────────────────────────────────────────
                    // Figma: #8145:10239 "arrow-left-01"
                    //   locationRelativeToParent: x=8, y=64
                    //   dimensions: 28x28
                    //   fills: #FFFFFF, Shadow, borderRadius: 8px
                    Positioned(
                      left: 8,
                      bottom: 8, // 100 - 64 - 28 = 8px from bottom
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white, // Figma: fill_658ab2fa = #FFFFFF
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14002B2B), // Figma Shadow
                              blurRadius: 4,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Icon(
                            isGridMode ? Icons.arrow_back_ios_new : Icons.add,
                            size: 16,
                            color: isGridMode ? const Color(0xFF1B1B1B) : const Color(0xFFA3090F),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Content area: padding 12px, gap 8px ──────────────────────
              // Figma: #8145:10240 padding=12px, gap=8px
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // Product name: Mobile/Body Rmd → fontSize:12, weight:400
                      // lineHeight 1.2 (vs Figma 1.3em) to fit in 39px budget after border
                      Flexible(
                        child: Text(
                          item.name,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Expo Arabic',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.2,
                            color: Color(0xFF1B1B1B),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Price: Mobile/12 m → fontSize:12, weight:500
                      Text(
                        '${item.price.toFormattedPrice()} ج.م',
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Expo Arabic',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                          color: Color(0xFF1B1B1B),
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
}

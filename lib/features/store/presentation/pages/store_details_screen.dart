import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:food_user_app/core/di/injection_container.dart';
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/app_spacing.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/app_media.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_category.dart';
import 'package:food_user_app/features/restaurant/domain/entities/restaurant.dart';
import 'package:food_user_app/features/restaurant/presentation/widgets/product_card.dart';
import 'package:food_user_app/features/search/presentation/models/results_config.dart';
import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/features/store/presentation/cubit/store_detail_cubit.dart';
import 'package:food_user_app/features/store/presentation/cubit/store_detail_state.dart';
import 'package:food_user_app/core/utils/category_icon_helper.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

class StoreDetailsScreen extends StatelessWidget {
  final String storeId;

  const StoreDetailsScreen({super.key, required this.storeId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<StoreDetailCubit>()..loadStoreDetails(storeId),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground(context),
        body: BlocListener<CartCubit, CartState>(
          listener: (context, state) {
            state.maybeWhen(
              conflict: (cart, newRestaurantId, menuItemId, name, price, quantity, modifiers, notes) {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(AppLocalizations.of(context)!.cartConflictTitle),
                    content: Text(AppLocalizations.of(context)!.cartConflictMessage),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(AppLocalizations.of(context)!.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          context.read<CartCubit>().clearAndAddToCart(
                            restaurantId: newRestaurantId,
                            menuItemId: menuItemId,
                            name: name,
                            price: price,
                            quantity: quantity,
                            selectedModifiers: modifiers,
                            notes: notes,
                          );
                        },
                        child: Text(AppLocalizations.of(context)!.continueButton),
                      ),
                    ],
                  ),
                );
              },
              orElse: () {},
            );
          },
          child: BlocBuilder<StoreDetailCubit, StoreDetailState>(
          builder: (context, state) {
            return state.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (msg) => Center(child: Text(msg, style: TextStyle(color: AppColors.error))),
              loaded: (store, categories, featuredProducts) {
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildCustomHeader(context, store)),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    const SliverToBoxAdapter(child: _PromoBanners()),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    _buildSectionTitle(context, 'تسوّق حسب التصنيفات'),
                    _buildCategoryGrid(context, store.id, categories),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    _buildSectionTitle(context, 'المنتجات الاكثر طلباً'),
                    _buildFeaturedProducts(context, featuredProducts),
                    const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
                  ],
                );
              },
            );
          },
        ),
        ),
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context, Restaurant store) {
    final topPadding = MediaQuery.paddingOf(context).top;

    final contentHeight = 16.0 + 36.0 + 17.0 + 44.0 + 20.0; // 133

    return Container(
      height: topPadding + contentHeight, 
      decoration: const BoxDecoration(color: AppColors.primary),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background decorations
          Positioned.fill(
            child: const Opacity(
              opacity: 0.1,
              child: AppRasterImage.asset(
                AppAssets.homeHeaderDecoration,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            top: 24,
            child: AppRasterImage.asset(
              AppAssets.homeHeaderDecorativeGroup,
              height: 167,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Content Column
          PositionedDirectional(
            top: topPadding + 16,
            start: AppSpacing.md,
            end: AppSpacing.md,
            child: Column(
              children: [
                // Top Row: Name & Back Button, Logo (Height 36)
                SizedBox(
                  height: 36,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Store Name and Back Button
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () => context.pop(),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceCard(context).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            store.name,
                            style: AppTextStyles.heading4(context).copyWith(
                              color: AppColors.surfaceCard(context),
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      // Store Logo
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard(context),
                          borderRadius: BorderRadius.circular(10), // Adjusted for smaller 36px size
                        ),
                        child: const AppRasterImage.asset(
                          AppAssets.storeIcon,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
                // Exact 17px gap
                const SizedBox(height: 17),
                // Search Entry
                GestureDetector(
                  onTap: () {
                    context.push(
                      RouteNames.unifiedResults,
                      extra: ResultsConfig(parentId: store.id, searchQuery: ' '),
                    );
                  },
                  child: Container(
                    height: 44,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard(context),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border(context)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: AppColors.hint(context), size: 20),
                        const SizedBox(width: 10),
                        Text(
                          'ابحث عن ما تحب',
                          style: AppTextStyles.body(context).copyWith(
                            color: AppColors.hint(context),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Wave divider
          Positioned(
            left: 0,
            right: 0,
            bottom: -1,
            child: AppRasterImage.asset(
              AppAssets.homeWaveDivider,
              height: 10,
              width: double.infinity,
              fit: BoxFit.fill,
              color: AppColors.scaffoldBackground(context),
              colorBlendMode: BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      sliver: SliverToBoxAdapter(
        child: Text(
          title, 
          style: AppTextStyles.heading4(context).copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedProducts(BuildContext context, featuredProducts) {
    if (featuredProducts.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 230, // Updated to accommodate ProductCard's 120px image + content
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          itemCount: featuredProducts.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            return Container(
              width: 125, // Adjusted to match Figma visual proportions (cards are smaller)
              margin: const EdgeInsets.only(right: 12),
              child: ProductCard(item: featuredProducts[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context, String storeId, List<MenuCategory> categories) {
    if (categories.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(AppLocalizations.of(context)!.noCategoriesAvailable, style: AppTextStyles.body(context)),
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 276, // Exact height for 3 rows of 84px + 2 spacings of 12px
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 rows
            mainAxisSpacing: 12, // Spacing between columns
            crossAxisSpacing: 12, // Spacing between rows
            childAspectRatio: 1.4, // height(84) / width(60) = 1.4
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return InkWell(
              onTap: () {
                context.push(
                  RouteNames.unifiedResults,
                  extra: ResultsConfig(parentId: storeId, categoryId: category.id),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60, // Fixed width
                    height: 60, // Fixed height
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7), // Light grey background like Figma
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Image.asset(
                      CategoryIconHelper.getLocalCategoryIcon(category.name),
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback if the specific local asset isn't added yet
                        return Image.asset(AppAssets.homeCategoryGrocery, fit: BoxFit.contain);
                      },
                    ),
                  ),
                  const SizedBox(height: 8), // Exact 8px spacing
                  Flexible(
                    child: Text(
                      category.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body(context).copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PromoBanners extends StatelessWidget {
  const _PromoBanners();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 120, // Approximate promo banner height
          child: PageView.builder(
            itemCount: 1, // Placeholder
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: Colors.red.shade900, // Fallback if image fails
                    child: const AppRasterImage.asset(
                      AppAssets.storeBanner, // Updated promo banner image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

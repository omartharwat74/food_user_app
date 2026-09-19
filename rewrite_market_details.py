import sys

new_content = """import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:food_user_app/core/di/injection_container.dart';
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/app_spacing.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/app_media.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_category.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_item.dart';
import 'package:food_user_app/features/market/domain/entities/market.dart';
import 'package:food_user_app/features/restaurant/presentation/widgets/product_card.dart';
import 'package:food_user_app/features/search/presentation/models/results_config.dart';
import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/features/market/presentation/cubit/market_details_cubit.dart';
import 'package:food_user_app/features/market/presentation/cubit/market_details_state.dart';
import 'package:food_user_app/features/store/presentation/cubit/hypermarket/hypermarket_cubit.dart';
import 'package:food_user_app/features/store/data/models/hyper_categories_response.dart';
import 'package:food_user_app/features/store/data/models/hyper_sections_response.dart';
import 'package:food_user_app/core/utils/category_icon_helper.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

class MarketDetailsScreen extends StatefulWidget {
  final String marketId;

  const MarketDetailsScreen({super.key, required this.marketId});

  @override
  State<MarketDetailsScreen> createState() => _MarketDetailsScreenState();
}

class _MarketDetailsScreenState extends State<MarketDetailsScreen> {
  late final MarketDetailsCubit _detailsCubit;
  late final HypermarketCubit _hyperCubit;

  @override
  void initState() {
    super.initState();
    _detailsCubit = sl<MarketDetailsCubit>()..loadMarketDetails(widget.marketId);
    _hyperCubit = sl<HypermarketCubit>()..fetchCategories(widget.marketId);
  }

  @override
  void dispose() {
    _detailsCubit.close();
    _hyperCubit.close();
    super.dispose();
  }

  MenuItem _fromHyperProduct(HyperProduct hp) {
    return MenuItem(
      id: hp.id.toString(),
      name: hp.name,
      description: hp.description ?? '',
      price: hp.priceAfterDiscount ?? hp.price,
      originalPrice: hp.price,
      imageUrl: hp.mainImage ?? '',
      available: hp.isAvailable,
      discountValue: 0,
      discountType: 'none',
      options: const [],
      includes: const [],
    );
  }

  MenuCategory _fromHyperCategory(HyperCategory hc) {
    return MenuCategory(
      id: hc.id.toString(),
      branchId: '',
      name: hc.name,
      imageUrl: hc.image,
      sortOrder: 0,
      items: const [],
      visible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _detailsCubit),
        BlocProvider.value(value: _hyperCubit),
      ],
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
          child: BlocBuilder<MarketDetailsCubit, MarketDetailsState>(
            builder: (context, state) {
              if (state is MarketDetailsLoading || state is MarketDetailsInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is MarketDetailsError) {
                return Center(child: Text(state.message, style: TextStyle(color: AppColors.error)));
              }
              if (state is MarketDetailsLoaded) {
                final store = state.market;
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildCustomHeader(context, store)),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    const SliverToBoxAdapter(child: _PromoBanners()),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    
                    _buildSectionTitle(context, 'تسوّق حسب التصنيفات'),
                    BlocBuilder<HypermarketCubit, HypermarketState>(
                      builder: (context, hyperState) {
                        if (hyperState is HypermarketLoading || hyperState is HypermarketInitial) {
                          return const SliverToBoxAdapter(
                            child: SizedBox(
                              height: 276,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          );
                        }
                        if (hyperState is HypermarketLoaded) {
                          final cats = hyperState.categories.map(_fromHyperCategory).toList();
                          return _buildCategoryGrid(context, store.id, cats);
                        }
                        return const SliverToBoxAdapter(child: SizedBox.shrink());
                      },
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    
                    _buildSectionTitle(context, 'المنتجات الاكثر طلباً'),
                    BlocBuilder<HypermarketCubit, HypermarketState>(
                      builder: (context, hyperState) {
                        if (hyperState is HypermarketLoading || hyperState is HypermarketInitial) {
                          return const SliverToBoxAdapter(
                            child: SizedBox(
                              height: 230,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          );
                        }
                        if (hyperState is HypermarketLoaded) {
                          // Flatten products from all sections to simulate featured products
                          final List<HyperProduct> allProducts = [];
                          for (var section in hyperState.sections) {
                            allProducts.addAll(section.products);
                          }
                          final featuredItems = allProducts.map(_fromHyperProduct).toList();
                          return _buildFeaturedProducts(context, featuredItems);
                        }
                        return const SliverToBoxAdapter(child: SizedBox.shrink());
                      },
                    ),
                    const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context, Market store) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final contentHeight = 16.0 + 36.0 + 17.0 + 44.0 + 20.0; // 133

    return Container(
      height: topPadding + contentHeight, 
      decoration: const BoxDecoration(color: AppColors.primary),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: const Opacity(
              opacity: 0.1,
              child: AppRasterImage.asset(
                AppAssets.homeHeaderDecoration,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
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
          PositionedDirectional(
            top: topPadding + 16,
            start: AppSpacing.md,
            end: AppSpacing.md,
            child: Column(
              children: [
                SizedBox(
                  height: 36,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard(context),
                          borderRadius: BorderRadius.circular(10), 
                        ),
                        child: store.logoImage != null && store.logoImage!.isNotEmpty
                          ? AppRasterImage.network(store.logoImage!, fit: BoxFit.cover)
                          : const AppRasterImage.asset(AppAssets.storeIcon, fit: BoxFit.contain),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 17),
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

  Widget _buildFeaturedProducts(BuildContext context, List<MenuItem> featuredProducts) {
    if (featuredProducts.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 230, 
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          itemCount: featuredProducts.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            return Container(
              width: 125,
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
        height: 276,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, 
            mainAxisSpacing: 12, 
            crossAxisSpacing: 12, 
            childAspectRatio: 1.4, 
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
                    width: 60, 
                    height: 60, 
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7), 
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: (category.imageUrl != null && category.imageUrl!.isNotEmpty)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AppRasterImage.network(category.imageUrl!, width: 40, height: 40, fit: BoxFit.contain)
                        )
                      : Image.asset(
                          CategoryIconHelper.getLocalCategoryIcon(category.name),
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(AppAssets.homeCategoryGrocery, fit: BoxFit.contain);
                          },
                        ),
                  ),
                  const SizedBox(height: 8), 
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
          height: 120, 
          child: PageView.builder(
            itemCount: 1, 
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: Colors.red.shade900,
                    child: const AppRasterImage.asset(
                      AppAssets.storeBanner, 
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
"""
with open('lib/features/market/presentation/pages/market_details_screen.dart', 'w', encoding='utf-8') as f:
    f.write(new_content)

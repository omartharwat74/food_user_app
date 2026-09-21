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
              loaded: (cart, promo) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إضافة المنتج للسلة بنجاح'),
                    backgroundColor: Colors.green,
                  ),
                );
                if (!(ModalRoute.of(context)?.isCurrent ?? true)) {
                  Navigator.of(context).pop();
                }
              },
              error: (cart, promo, message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: Colors.red,
                  ),
                );
              },

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
                    SliverToBoxAdapter(child: _PromoBanners(store: store)),
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
          const Positioned.fill(
            child: ColoredBox(color: AppColors.primary),
          ),
          const Positioned.fill(
            child: AppRasterImage.asset(
              AppAssets.headerPattern,
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
                        child: Image.network(store.logoImage ?? '', fit: BoxFit.cover),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 17),
                GestureDetector(
                  onTap: () {
                    context.push(RouteNames.storeSearchFor(store.id));
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
      // Figma: horizontal 16px margin, 12px vertical spacing
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          title,
          textAlign: TextAlign.right,
          // Figma: Mobile/H4 → fontFamily: Expo Arabic, fontWeight: 600, fontSize: 15, color: #1B1B1B
          style: const TextStyle(
            fontFamily: 'Expo Arabic',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            height: 1.4,
            color: Color(0xFF1B1B1B),
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
        // Figma card height = 164px. Add 12px bottom margin for shadow clearance.
        height: 176,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          itemCount: featuredProducts.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            return SizedBox(
              // Figma: EL-0dee7c3e layout width = 134px
              width: 134,
              child: ProductCard(
                item: featuredProducts[index],
                isGridMode: false,
              ),
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
                  extra: ResultsConfig(
                    parentId: storeId, 
                    categoryId: category.id,
                    categoryName: category.name,
                  ),
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
                          child: Image.network(category.imageUrl!, width: 40, height: 40, fit: BoxFit.contain)
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

class _PromoBanners extends StatefulWidget {
  final Market store; // Note: Change 'Market' to your exact entity name if different
  const _PromoBanners({required this.store});

  @override
  State<_PromoBanners> createState() => _PromoBannersState();
}

class _PromoBannersState extends State<_PromoBanners> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<String> apiImages = [];
    
    // Fallback: Cover Image -> Logo Image
    if (widget.store.coverImage != null && widget.store.coverImage!.isNotEmpty) {
      apiImages.add(widget.store.coverImage!);
    } else if (widget.store.logoImage != null && widget.store.logoImage!.isNotEmpty) {
      apiImages.add(widget.store.logoImage!);
    }

    if (apiImages.isEmpty) return const SizedBox.shrink();

    // Force swipeability: if only 1 image exists, duplicate it to 3 slides so the user can swipe and see dots.
    final displayImages = apiImages.length == 1 
        ? [apiImages[0], apiImages[0], apiImages[0]] 
        : apiImages;

    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            itemCount: displayImages.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.network(
                  displayImages[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => const ColoredBox(color: Colors.grey),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            displayImages.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentIndex == index ? AppColors.primary : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

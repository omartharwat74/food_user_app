import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:food_user_app/core/di/injection_container.dart';
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/app_spacing.dart';
import 'package:food_user_app/core/widgets/promo_banner_card.dart';
import 'package:food_user_app/features/home/domain/entities/banner.dart';
import 'package:food_user_app/features/product/presentation/pages/product_details_screen.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_item.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/product_detail_cubit.dart';
import 'package:food_user_app/features/search/presentation/models/results_config.dart';
import 'package:food_user_app/features/store/domain/repositories/store_repository.dart';

class StoreBannerSlider extends StatefulWidget {
  final String storeId;
  final String? fallbackImageUrl;
  final String? fallbackTitle;

  const StoreBannerSlider({
    super.key,
    required this.storeId,
    this.fallbackImageUrl,
    this.fallbackTitle,
  });

  @override
  State<StoreBannerSlider> createState() => _StoreBannerSliderState();
}

class _StoreBannerSliderState extends State<StoreBannerSlider> {
  late final PageController _controller;
  int _currentPage = 0;
  List<BannerItem> _banners = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _fetchBanners();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchBanners() async {
    final result = await sl<StoreRepository>().getStoreBanners(widget.storeId);
    if (!mounted) return;
    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
        });
      },
      (banners) {
        setState(() {
          _banners = banners;
          _isLoading = false;
        });
      },
    );
  }

  void _onBannerTap(BannerItem banner) async {
    if (banner.type == 'product' ||
        (banner.productId != null && banner.productId! > 0)) {
      final productId = banner.productId?.toString() ?? '';
      if (productId.isNotEmpty) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (ctx) => BlocProvider<ProductDetailCubit>(
            create: (_) => sl<ProductDetailCubit>()..fetchProductDetails(productId),
            child: ProductDetailsScreen(
              item: MenuItem(
                id: productId,
                name: banner.title ?? '',
                description: '',
                price: 0,
                originalPrice: 0,
                imageUrl: banner.imageUrl ?? '',
                available: true,
              ),
            ),
          ),
        );
      }
    } else if (banner.type == 'category' ||
        (banner.menuCategoryId != null && banner.menuCategoryId! > 0)) {
      context.push(
        RouteNames.unifiedResults,
        extra: ResultsConfig(
          parentId: widget.storeId,
          categoryId: banner.menuCategoryId.toString(),
          categoryName: banner.title,
        ),
      );
    } else if (banner.type == 'store' ||
        (banner.storeId != null && banner.storeId! > 0)) {
      context.push(RouteNames.restaurantDetailFor(banner.storeId.toString()));
    } else if (banner.type == 'link' ||
        (banner.link != null && banner.link!.isNotEmpty)) {
      final uri = Uri.tryParse(banner.link!);
      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 125,
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (page) => setState(() => _currentPage = page),
              itemCount: _banners.length,
              itemBuilder: (context, index) {
                final banner = _banners[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: PromoBannerCard(
                    banner: banner,
                    onTap: () => _onBannerTap(banner),
                  ),
                );
              },
            ),
          ),
          if (_banners.length > 1) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_banners.length, (index) {
                final isActive = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary
                        : AppColors.border(context),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ],
        ],
      ),
    );
  }
}

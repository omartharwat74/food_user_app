import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/app_media.dart';
import 'package:food_user_app/core/widgets/app_status_dot_label.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:food_user_app/features/service_listing/presentation/models/service_listing_config.dart';
import 'package:food_user_app/features/restaurant/presentation/models/restaurant_detail_args.dart';

class SharedStoreListTile extends StatelessWidget {
  const SharedStoreListTile({
    required this.item,
    super.key,
  });

  final ServicePlaceData item;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final l10n = AppLocalizations.of(context)!;
    final hasDiscount = item.hasOffer;
    final cardHeight = hasDiscount ? 70.0 : 56.0;

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 6),
      child: Container(
        height: cardHeight,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              final storeId = item.id ?? _detailId(item.name);
              debugPrint('🛠️ Tapped Store: ${item.name} | isMajor: ${item.isMajor}');
              if (item.isMajor == true) {
                context.push(RouteNames.marketDetailsFor(storeId.toString()));
              } else {
                context.push(
                  RouteNames.restaurantDetailFor(storeId.toString()),
                  extra: _toRestaurantDetailArgs(item),
                );
              }
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          _PlaceImage(item: item),
                          const SizedBox(width: 10), // gap: 10px
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        item.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        style: AppTextStyles.body(context).copyWith(
                                          fontSize: 12,
                                          height: 1.3,
                                          fontWeight: FontWeight.w500, // Mobile/12 m
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4), // gap: 4px
                                    AppStatusDotLabel(
                                      label: l10n.serviceAvailable,
                                      color: AppColors.success,
                                    ),
                                  ],
                                ),
                                SizedBox(height: hasDiscount ? 8 : 4), // Dynamic gap
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    _RatingLabel(rating: item.rating),
                                    const SizedBox(width: 12), // gap: 12px
                                    _TimeLabel(time: item.time),
                                  ],
                                ),
                                if (hasDiscount) ...[
                                  const SizedBox(height: 8), // gap: 8px
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0C9D61),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AppSvgImage.asset(
                                          AppAssets.serviceSaleIcon,
                                          width: 12,
                                          height: 12,
                                        ),
                                        const SizedBox(width: 4),
                                        const Text(
                                          'خصومات تصل إلى 20 % ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontFamily: 'Expo Arabic',
                                            fontWeight: FontWeight.w500,
                                            height: 1.25,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                                    SizedBox(
                    width: 20,
                    height: 20,
                    child: Center(
                      child: Transform.scale(
                        scaleX: isRtl ? -1 : 1,
                        child: AppSvgImage.asset(
                          AppAssets.serviceBackIcon,
                          width: 12,
                          height: 12,
                          color: AppColors.onSurface(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _detailId(String name) {
    final normalized = name
        .toLowerCase()
        .replaceAll(' ', '-')
        .replaceAll(RegExp(r'[^a-z0-9\u0600-\u06FF-]'), '');
    return normalized.isEmpty ? 'service-place' : normalized;
  }

  RestaurantDetailArgs _toRestaurantDetailArgs(ServicePlaceData item) {
    return RestaurantDetailArgs(
      id: item.id ?? _detailId(item.name),
      name: item.name,
      description: item.subtitle ?? item.name,
      deliveryTime: item.time,
      rating: double.tryParse(item.rating) ?? 4.5,
      logoAsset: item.imageAsset,
      coverAsset: item.imageAsset,
    );
  }
}

class _PlaceImage extends StatelessWidget {
  const _PlaceImage({required this.item});

  final ServicePlaceData item;

  Widget _buildImage(
    String path, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return AppNetworkImage(path, width: width, height: height, fit: fit);
    }
    return AppRasterImage.asset(path, width: width, height: height, fit: fit);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildImage(
                item.imageAsset,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (item.showFavourite)
            PositionedDirectional(
              top: 6,
              start: 6,
              child: Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard(context),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: AppSvgImage.asset(
                  AppAssets.serviceFavouriteIcon,
                  width: 14,
                  height: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TimeLabel extends StatelessWidget {
  const _TimeLabel({
    required this.time,
  });

  final String time;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.onSurface(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final minLabel = isRtl ? 'دقيقة' : 'mins';
    
    // Clean up any existing "min", "mins", or "دقيقة"
    var cleanTime = time.replaceAll(RegExp(r'\s*(mins?|دقيقة)'), '').trim();
    if (cleanTime.isEmpty) cleanTime = time; 
    final displayTime = '$cleanTime $minLabel';

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppRasterImage.asset(
          AppAssets.serviceTimeIconPng,
          width: 14,
          height: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            displayTime,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption(
              context,
            ).copyWith(color: color, fontSize: 10, height: 1.0),
          ),
        ),
      ],
    );
  }
}

class _RatingLabel extends StatelessWidget {
  const _RatingLabel({required this.rating});

  final String rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppSvgImage.asset(AppAssets.serviceStarIcon, width: 14, height: 14),
        const SizedBox(width: 2),
        Text(
          rating,
          style: AppTextStyles.body(
            context,
          ).copyWith(fontSize: 10, height: 1.0),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/app_radius.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/app_media.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:food_user_app/features/restaurant/domain/entities/restaurant.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/favorite_cubit.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/favorite_state.dart';
import 'package:food_user_app/features/restaurant/presentation/models/restaurant_detail_args.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final double width;

  const RestaurantCard({required this.restaurant, this.width = 223, super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Material(
      color: AppColors.surfaceCard(context),
      borderRadius: const BorderRadius.all(AppRadius.md),
      child: InkWell(
        borderRadius: const BorderRadius.all(AppRadius.md),
        onTap: () => context.push(
          RouteNames.restaurantDetailFor(restaurant.id),
          extra: RestaurantDetailArgs(
            id: restaurant.id,
            name: restaurant.name,
            description: restaurant.cuisineType,
            deliveryTime:
                '${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} min',
            rating: restaurant.rating,
            logoAsset: restaurant.coverImageUrl.isNotEmpty
                ? restaurant.coverImageUrl
                : AppAssets.restaurantAzAlShamLogo,
            coverAsset: restaurant.coverImageUrl.isNotEmpty
                ? restaurant.coverImageUrl
                : AppAssets.restaurantHeroBurger,
            initialFavorite: restaurant.isFavorited,
          ),
        ),
        child: Container(
          width: width,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: Border.all(color: AppColors.border(context), width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 124,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: restaurant.coverImageUrl.isNotEmpty
                            ? AppNetworkImage(
                                restaurant.coverImageUrl,
                                fit: BoxFit.cover,
                              )
                            : const AppRasterImage.asset(
                                AppAssets.restaurantHeroBurger,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Positioned(
                      left: isArabic ? 10 : null,
                      right: isArabic ? null : 10,
                      top: 10,
                      child: BlocBuilder<FavoriteCubit, FavoriteState>(
                        builder: (context, state) {
                          final favoriteIds = state.maybeWhen(
                            loaded: (ids, restaurants) => ids,
                            error: (ids, restaurants, message) => ids,
                            orElse: () => restaurant.isFavorited
                                ? {restaurant.id}
                                : <String>{},
                          );
                          final isFav = favoriteIds.contains(restaurant.id);

                          return GestureDetector(
                            onTap: () {
                              context.read<FavoriteCubit>().toggleFavorite(
                                restaurant.id,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isFav
                                        ? AppLocalizations.of(context)!.itemRemovedFromFavorites
                                        : AppLocalizations.of(context)!.itemAddedToFavorites,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceCard(context),
                                borderRadius: const BorderRadius.all(
                                  AppRadius.full,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  isFav
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  restaurant.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  style: AppTextStyles.body(context).copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              _AvailabilityBadge(availability: restaurant.availability),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        _RatingBadge(
                          rating: (restaurant.rating).toStringAsFixed(1),
                        ),
                      ],
                    ),
                    if (restaurant.tags.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        restaurant.tags.join(' ، '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: AppTextStyles.caption(context).copyWith(fontSize: 10, height: 1.25),
                      ),
                    ] else
                      const SizedBox.shrink(),
                    const SizedBox(height: 8),
                    Text(
                      restaurant.cuisineType,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: AppTextStyles.caption(
                        context,
                      ).copyWith(fontSize: 10, height: 1.25),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          color: AppColors.metaIcon,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isArabic
                              ? "${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} دقيقة"
                              : "${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} min",
                          style: AppTextStyles.caption(context).copyWith(
                            fontSize: 10,
                            height: 1.25,
                            color: AppColors.onSurface(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});

  final String rating;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    const icon = Icon(
      Icons.star_rounded,
      color: AppColors.ratingStar,
      size: 14,
    );
    final text = Text(
      rating,
      style: AppTextStyles.body(context).copyWith(fontSize: 10, height: 1.25),
    );

    return Container(
      padding: const EdgeInsetsDirectional.all(4),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground(context),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: isRtl
            ? [icon, const SizedBox(width: 2), text]
            : [text, const SizedBox(width: 2), icon],
      ),
    );
  }
}


class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge({required this.availability});
  final String availability;

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;
    switch (availability.toLowerCase()) {
      case 'busy':
        color = const Color(0xFFEFBE1C);
        text = 'مشغول';
        break;
      case 'closed':
        color = const Color(0xFFEC2D30);
        text = 'مغلق';
        break;
      case 'open':
      default:
        color = const Color(0xFF0C9D61);
        text = 'متاح';
        break;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          text,
          style: AppTextStyles.caption(context).copyWith(
            fontSize: 10,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

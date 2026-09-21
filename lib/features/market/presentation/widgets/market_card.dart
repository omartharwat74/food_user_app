import 'package:flutter/material.dart';
import 'package:food_user_app/core/utils/price_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/market.dart';
import '../cubit/market_favorite_cubit.dart';
import '../cubit/market_favorite_state.dart';

class MarketCard extends StatelessWidget {
  final Market market;
  final VoidCallback? onTap;

  const MarketCard({
    super.key,
    required this.market,
    this.onTap,
  });

  Future<void> _handleFavoriteTap(BuildContext context) async {
    final tokenStorage = GetIt.I<TokenStorage>();
    final token = await tokenStorage.getAccessToken();

    if (token == null || token.isEmpty) {
      if (!context.mounted) return;
      _showAuthGateDialog(context);
      return;
    }

    if (!context.mounted) return;
    final cubit = context.read<MarketFavoriteCubit>();
    final isFav = cubit.isFavorite(market.id, fallback: market.isFavorite);

    cubit.toggleFavorite(
      marketId: market.id,
      currentFavoriteStatus: isFav,
    );
  }

  void _showAuthGateDialog(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          isArabic ? 'تسجيل الدخول مطلوب' : 'Sign In Required',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          isArabic
              ? 'يرجى تسجيل الدخول لإضافة المفضلة واستخدام كامل الخدمات.'
              : 'Please sign in to add markets to your favorites.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              isArabic ? 'إلغاء' : 'Cancel',
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.push(RouteNames.authEntry);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isArabic ? 'تسجيل الدخول' : 'Sign In',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final theme = Theme.of(context);

    return BlocBuilder<MarketFavoriteCubit, MarketFavoriteState>(
      builder: (context, state) {
        final favoriteCubit = context.read<MarketFavoriteCubit>();
        final isFav = favoriteCubit.isFavorite(
          market.id,
          fallback: market.isFavorite,
        );

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap ??
                () {
                  context.push(RouteNames.marketDetailsFor(market.id));
                },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Cover Image Header ────────────────────────────────────────
                Stack(
                  children: [
                    Container(
                      height: 140,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: (market.coverImage != null && market.coverImage!.isNotEmpty)
                          ? Image.network(
                              market.coverImage!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => (market.logoImage != null && market.logoImage!.isNotEmpty)
                                  ? Image.network(market.logoImage!, fit: BoxFit.cover)
                                  : const ColoredBox(color: Colors.grey),
                            )
                          : (market.logoImage != null && market.logoImage!.isNotEmpty)
                              ? Image.network(market.logoImage!, fit: BoxFit.cover)
                              : const ColoredBox(color: Colors.grey),
                    ),

                    // Pickup Badge
                    if (market.pickupAvailable)
                      Positioned.directional(
                        textDirection: Directionality.of(context),
                        start: 12,
                        top: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isArabic ? 'استلام من الفرع' : 'Pickup Available',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    // Favorite Heart Icon
                    Positioned.directional(
                      textDirection: Directionality.of(context),
                      end: 12,
                      top: 12,
                      child: GestureDetector(
                        onTap: () => _handleFavoriteTap(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? AppColors.primary : Colors.grey,
                            size: 20,
                          ),
                        ),
                      ),
                    ),

                    // Market Logo Overlay
                    Positioned.directional(
                      textDirection: Directionality.of(context),
                      start: 16,
                      bottom: 8,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 4),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: (market.logoImage != null && market.logoImage!.isNotEmpty)
                            ? Image.network(
                                market.logoImage!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.store,
                                  color: Colors.grey,
                                  size: 28,
                                ),
                              )
                            : const Icon(
                                Icons.store,
                                color: Colors.grey,
                                size: 28,
                              ),
                      ),
                    ),
                  ],
                ),

                // ── Card Details ──────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              market.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Rating
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: AppColors.ratingStar,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${market.rating.toStringAsFixed(1)} (${market.ratingCount})',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Delivery info row
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_filled,
                            size: 14,
                            color: theme.hintColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isArabic
                                ? '${market.deliveryTimeMin}-${market.deliveryTimeMax} دقيقة'
                                : '${market.deliveryTimeMin}-${market.deliveryTimeMax} min',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.hintColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.delivery_dining,
                            size: 16,
                            color: theme.hintColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            market.deliveryFee == 0
                                ? (isArabic ? 'مجاني' : 'Free')
                                : '${market.deliveryFee.toFormattedPrice()} ${isArabic ? "ج.م" : "EGP"}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.hintColor,
                            ),
                          ),
                          const Spacer(),
                          if (!market.isAvailable)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.errorTint,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                isArabic ? 'مغلق' : 'Closed',
                                style: const TextStyle(
                                  color: AppColors.error,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
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
        );
      },
    );
  }
}

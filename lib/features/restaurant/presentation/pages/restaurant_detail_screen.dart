import 'package:food_user_app/features/restaurant/presentation/widgets/menu_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/app_radius.dart';
import 'package:food_user_app/core/theme/app_spacing.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/app_media.dart';
import 'package:food_user_app/core/widgets/app_status_dot_label.dart';
import 'package:food_user_app/core/widgets/liquid_glass_button.dart';


import 'package:food_user_app/features/restaurant/presentation/models/restaurant_detail_args.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/di/injection_container.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_category.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_item.dart';
import 'package:food_user_app/features/restaurant/domain/entities/restaurant.dart';

import 'package:food_user_app/features/restaurant/presentation/cubit/menu_cubit.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/favorite_cubit.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/favorite_state.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/restaurant_detail_cubit.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/restaurant_detail_state.dart';

// ── Layout constants ───────────────────────────────────────────────────────────────
/// Height of the restaurant hero background section.
const double _kHeroHeight = 180.0;

/// Y-offset within the scrolling block at which the info card appears.
/// Card overlaps the hero by `_kHeroHeight - _kInfoCardTopOffset = 52 px`.
const double _kInfoCardTopOffset = 128.0;

/// Total content height of the collapsing header (hero + card).
/// card bottom = _kInfoCardTopOffset + 96.0 (dynamic card height) = 224.
const double _kHeaderContentHeight = 224.0;

/// Height of the sticky _MenuTabs bar.
const double _kTabBarHeight = 34.0;

// ─────────────────────────────────────────────────────────────────────────────

class RestaurantDetailScreen extends StatefulWidget {
  const RestaurantDetailScreen({
    this.restaurantId = 'az-al-sham',
    this.restaurant,
    super.key,
  });

  final String restaurantId;
  final RestaurantDetailArgs? restaurant;

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  final _scrollController = ScrollController();
  List<GlobalKey> _sectionKeys = [];
  int _selectedCategoryIndex = 0;
  bool _isProgrammaticScroll = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateSelectedSectionFromScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_updateSelectedSectionFromScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final copy = _RestaurantDetailCopy.of(context);
    final topPadding = MediaQuery.paddingOf(context).top;

    // minExtent: only the pinned AppBar row (safe area + toolbar height).
    final minExtent = topPadding + kToolbarHeight;

    // maxExtent: pinned AppBar row + hero + info card area.
    final maxExtent = _kHeaderContentHeight;

    final favoriteState = context.watch<FavoriteCubit>().state;
    final isFav = favoriteState.maybeWhen(
      loaded: (ids, _) => ids.contains(widget.restaurantId),
      orElse: () => false,
    );

    return MultiBlocProvider(
      providers: [
        // MenuCubit is still available for item modifier lookups
        BlocProvider<MenuCubit>(
          create: (context) => sl<MenuCubit>(),
        ),
        BlocProvider<RestaurantDetailCubit>(
          create: (context) =>
              sl<RestaurantDetailCubit>()..fetchStoreData(widget.restaurantId),
        ),
      ],
      child: BlocBuilder<RestaurantDetailCubit, RestaurantDetailState>(
        builder: (context, detailState) {
          return detailState.when(
            initial: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
            loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
            error: (message) => Scaffold(body: Center(child: Text(message))),
            loaded: (restaurant, menuCategories, branches, offers) {
              if (_sectionKeys.length != menuCategories.length) {
                _sectionKeys = List.generate(
                  menuCategories.length,
                  (_) => GlobalKey(),
                );
              }

              return Scaffold(
                backgroundColor: AppColors.scaffoldBackground(context),
                body: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    // ── 1. Collapsing hero + info-card header ──────────────────────────
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _RestaurantHeaderDelegate(
                        minExtent: minExtent,
                        maxExtent: maxExtent,
                        hero: _RestaurantHero(imageUrl: restaurant.coverImageUrl),
                        infoCard: _RestaurantInfoCard(
                          restaurant: restaurant,
                          locale: locale,
                          copy: copy,
                        ),
                        restaurantName: restaurant.name,
                        restaurantId: restaurant.id,
                        isFavorite: isFav,
                        onFavoriteTap: () {
                          context.read<FavoriteCubit>().toggleFavorite(restaurant.id);
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
                      ),
                    ),

                    // ── 2. Scrolling coupon strip ──────────────────────────────────────
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(vertical: 21),
                      sliver: SliverToBoxAdapter(child: _CouponStrip(copy: copy)),
                    ),

                    // ── 3. Sticky category tabs ────────────────────────────────────────
                    if (menuCategories.isNotEmpty)
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _MenuTabsDelegate(
                          minExtent: _kTabBarHeight,
                          maxExtent: _kTabBarHeight,
                          categories: menuCategories.map((c) => c.name).toList(),
                          selectedIndex: _selectedCategoryIndex,
                          onTap: _scrollToCategory,
                        ),
                      )
                    else
                      const SliverToBoxAdapter(child: SizedBox.shrink()),

                    // ── 4. Menu sections ────────────────────────────────────────────────
                    if (menuCategories.isEmpty)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          AppSpacing.md,
                          20,
                          AppSpacing.md,
                          40,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: _MenuSections(
                            sections: menuCategories,
                            sectionKeys: _sectionKeys,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _scrollToCategory(int categoryIndex) async {
    setState(() => _selectedCategoryIndex = categoryIndex);

    final sectionContext = _sectionKeys[categoryIndex].currentContext;
    if (sectionContext == null) return;

    final renderObject = sectionContext.findRenderObject();
    if (renderObject is! RenderBox || !_scrollController.hasClients) return;

    final sectionTop = renderObject.localToGlobal(Offset.zero).dy;

    // Account for the pinned AppBar height + sticky tab bar height + 16px gap
    // so the section header is not hidden or touching the pinned headers.
    final topPadding = MediaQuery.paddingOf(context).top;
    final stickyHeadersHeight =
        topPadding + kToolbarHeight + _kTabBarHeight + 16.0;
    final targetOffset =
        (_scrollController.offset + sectionTop - stickyHeadersHeight).clamp(
          _scrollController.position.minScrollExtent,
          _scrollController.position.maxScrollExtent,
        );

    _isProgrammaticScroll = true;
    await _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );

    if (!mounted) return;
    _isProgrammaticScroll = false;
  }

  void _updateSelectedSectionFromScroll() {
    if (_isProgrammaticScroll || !_scrollController.hasClients) return;

    // Detection threshold: top of viewport + pinned headers height + a small
    // offset so the "next" section only activates once it's clearly visible.
    final topPadding = MediaQuery.paddingOf(context).top;
    final detectionOffset = topPadding + kToolbarHeight + _kTabBarHeight + 16.0;

    var activeSectionIndex = 0;

    for (var i = 0; i < _sectionKeys.length; i++) {
      final sectionContext = _sectionKeys[i].currentContext;
      if (sectionContext == null) continue;

      final renderObject = sectionContext.findRenderObject();
      if (renderObject is! RenderBox) continue;

      final top = renderObject.localToGlobal(Offset.zero).dy;
      if (top <= detectionOffset) {
        activeSectionIndex = i;
      }
    }

    if (activeSectionIndex != _selectedCategoryIndex) {
      setState(() => _selectedCategoryIndex = activeSectionIndex);
    }
  }
}

// ── Collapsing header delegate ────────────────────────────────────────────────

/// [SliverPersistentHeaderDelegate] that achieves a Talabat-style parallax
/// scroll. There are two layers rendered in a [Stack]:
///
/// **Layer 1 — scrolling background:** The [hero] and [infoCard] sit inside a
/// [Positioned] whose `top` is driven by `-shrinkOffset`. This makes the entire
/// block scroll upward at exactly the same speed as the user's finger, giving a
/// natural "content scrolls behind a window" feel. The card is never faded —
/// it simply clips behind the pinned AppBar.
///
/// **Layer 2 — pinned AppBar:** A [Positioned] locked to `top: 0`. It holds
/// the Back / Search / Favorite action buttons (always visible) plus the
/// restaurant title that fades in once the card has scrolled away. The
/// background of this row fades from transparent to [AppColors.primary].
class _RestaurantHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _RestaurantHeaderDelegate({
    required this.minExtent,
    required this.maxExtent,
    required this.hero,
    required this.infoCard,
    required this.restaurantName,
    required this.restaurantId,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  @override
  final double minExtent;
  @override
  final double maxExtent;

  final Widget hero;
  final Widget infoCard;
  final String restaurantName;
  final String restaurantId;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final shrinkFraction = (shrinkOffset / (maxExtent - minExtent)).clamp(
      0.0,
      1.0,
    );

    // AppBar background + title only appear in the last 15 % of the collapse,
    // so the transition feels snappy and reveals only after the card is gone.
    final appBarOpacity = shrinkFraction > 0.85
        ? ((shrinkFraction - 0.85) / 0.15).clamp(0.0, 1.0)
        : 0.0;

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final topPadding = MediaQuery.paddingOf(context).top;
    final isScrolled = shrinkFraction > 0.85;

    // ── Action buttons (always visible in the pinned AppBar row) ─────────────
    final backButton = _GlassIconButton(
      assetName: AppAssets.restaurantHeaderBackIcon,
      mirrorAsset: !isArabic,
      size: 28,
      iconWidth: 9,
      iconHeight: 16,
      isScrolled: isScrolled,
      onTap: () => Navigator.of(context).pop(),
    );

    final actionButtons = Row(
      textDirection: TextDirection.ltr,
      mainAxisSize: MainAxisSize.min,
      children: isArabic
          ? [
              _GlassIconButton(
                assetName: AppAssets.restaurantSearchIcon,
                iconWidth: 24,
                iconHeight: 24,
                isScrolled: isScrolled,
                onTap: () =>
                    context.push(RouteNames.restaurantSearchFor(restaurantId)),
              ),
              const SizedBox(width: 12),
              _GlassIconButton(
                assetName: isFavorite
                    ? AppAssets.restaurantFavoriteActiveIcon
                    : AppAssets.restaurantFavoriteIcon,
                iconWidth: 24,
                iconHeight: 24,
                isScrolled: isScrolled,
                onTap: onFavoriteTap,
              ),
            ]
          : [
              _GlassIconButton(
                assetName: isFavorite
                    ? AppAssets.restaurantFavoriteActiveIcon
                    : AppAssets.restaurantFavoriteIcon,
                iconWidth: 24,
                iconHeight: 24,
                isScrolled: isScrolled,
                onTap: onFavoriteTap,
              ),
              const SizedBox(width: 12),
              _GlassIconButton(
                assetName: AppAssets.restaurantSearchIcon,
                iconWidth: 24,
                iconHeight: 24,
                isScrolled: isScrolled,
                onTap: () =>
                    context.push(RouteNames.restaurantSearchFor(restaurantId)),
              ),
            ],
    );

    // 4 px fixed gap between back button and title start (SizedBox(width: 4)).
    // A Spacer after the title pushes action buttons to the trailing edge.
    Widget buildTitle({required bool alignEnd}) {
      return Opacity(
        opacity: appBarOpacity,
        child: Text(
          restaurantName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          style: AppTextStyles.heading4(context).copyWith(
            color: AppColors.onSurface(context),
            fontSize: 16,
            height: 1.4,
          ),
        ),
      );
    }

    return ClipRect(
      child: Stack(
        children: [
          // ── Layer 1: scrolling hero + info-card block ───────────────────────
          // By offsetting top by -shrinkOffset, content scrolls with the finger.
          // Height = maxExtent (topPadding + 244). The inner content is pushed
          // down by topPadding so the card bottom lands at exactly maxExtent,
          // which is the boundary where the next sliver starts. This eliminates
          // the ghost gap that appeared when height was only 244 px.
          Positioned(
            top: -shrinkOffset,
            left: 0,
            right: 0,
            height: maxExtent,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Hero background: starts at absolute top (0) and is exactly 180 px tall.
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: _kHeroHeight,
                  child: hero,
                ),
                // Info card: starts at exactly 128 px from top of the block.
                PositionedDirectional(
                  top: _kInfoCardTopOffset,
                  start: AppSpacing.md,
                  end: AppSpacing.md,
                  child: infoCard,
                ),
              ],
            ),
          ),

          // ── Layer 2: pinned AppBar row ──────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: minExtent,
            child: Container(
              // Background fades from transparent → solid AppColors.primary.
              color: AppColors.scaffoldBackground(
                context,
              ).withValues(alpha: appBarOpacity),
              padding: EdgeInsetsDirectional.fromSTEB(
                16,
                topPadding + 10,
                16,
                10,
              ),
              child: Row(
                textDirection: TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: isArabic
                    ? [
                        // Arabic: [actions] [spacer] [title] [4px] [back]
                        actionButtons,
                        const Spacer(),
                        buildTitle(alignEnd: true),
                        const SizedBox(width: 4),
                        backButton,
                      ]
                    : [
                        // LTR: [back] [4px] [title] [spacer] [actions]
                        backButton,
                        const SizedBox(width: 4),
                        buildTitle(alignEnd: false),
                        const Spacer(),
                        actionButtons,
                      ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _RestaurantHeaderDelegate oldDelegate) =>
      oldDelegate.minExtent != minExtent ||
      oldDelegate.maxExtent != maxExtent ||
      oldDelegate.restaurantName != restaurantName ||
      oldDelegate.isFavorite != isFavorite;
}

// ── Sticky category tabs delegate ─────────────────────────────────────────────

/// [SliverPersistentHeaderDelegate] that keeps [_MenuTabs] pinned below the
/// collapsing hero header once the coupon strip has scrolled out of view.
class _MenuTabsDelegate extends SliverPersistentHeaderDelegate {
  const _MenuTabsDelegate({
    required this.minExtent,
    required this.maxExtent,
    required this.categories,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  final double minExtent;
  @override
  final double maxExtent;

  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: AppColors.scaffoldBackground(context),
      child: _MenuTabs(
        categories: categories,
        selectedIndex: selectedIndex,
        onTap: onTap,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _MenuTabsDelegate oldDelegate) =>
      oldDelegate.selectedIndex != selectedIndex ||
      oldDelegate.categories != categories;
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

/// Pure visual background for the hero section.
/// Contains ONLY the red background, decorative food images, and dark overlay.
/// All interactive buttons live in [_RestaurantHeaderDelegate]'s pinned AppBar
/// layer so they remain always accessible regardless of scroll position.
class _RestaurantHero extends StatelessWidget {
  const _RestaurantHero({required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (imageUrl.isNotEmpty)
          AppNetworkImage(
            imageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          )
        else
          Container(color: AppColors.primary),
        Container(color: AppColors.black.withValues(alpha: 0.2)),
      ],
    );
  }
}

class _RestaurantInfoCard extends StatelessWidget {
  const _RestaurantInfoCard({
    required this.restaurant,
    required this.locale,
    required this.copy,
  });

  final Restaurant restaurant;
  final Locale locale;
  final _RestaurantDetailCopy copy;

  @override
  Widget build(BuildContext context) {
    final isArabic = locale.languageCode == 'ar';
    final backButton = IconButton(
      onPressed: () => context.pop(),
      visualDensity: VisualDensity.compact,
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: const Size(28, 28),
        padding: EdgeInsets.zero,
      ),
      icon: Transform.scale(
        scaleX: isArabic ? 1 : -1,
        child: const AppRasterImage.asset(
          AppAssets.restaurantInfoBackIcon,
          width: 20,
          height: 20,
        ),
      ),
    );
    final logo = ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: AppRasterImage.asset(
        AppAssets.homeRestaurantLogo,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
      ),
    );
    final restaurantText = Flexible(
      flex: 8,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          crossAxisAlignment: isArabic
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: isArabic
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                if (isArabic) _StatusPill(label: copy.available),
                if (isArabic) const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    restaurant.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: isArabic ? TextAlign.end : TextAlign.start,
                    style: AppTextStyles.body(context).copyWith(
                      fontSize: 14,
                      height: 1.45,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                if (!isArabic) const SizedBox(width: AppSpacing.sm),
                if (!isArabic) _StatusPill(label: copy.available),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              restaurant.description.isNotEmpty
                  ? restaurant.description
                  : restaurant.cuisineType,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: isArabic ? TextAlign.end : TextAlign.start,
              style: AppTextStyles.caption(
                context,
              ).copyWith(fontSize: 10, height: 1.25),
            ),
          ],
        ),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            textDirection: TextDirection.ltr,
            children: isArabic
                ? [
                    backButton,
                    const Spacer(),
                    restaurantText,
                    const SizedBox(width: AppSpacing.sm),
                    logo,
                  ]
                : [
                    logo,
                    const SizedBox(width: AppSpacing.sm),
                    restaurantText,
                    const Spacer(),
                    backButton,
                  ],
          ),
          const SizedBox(height: 12),
          Row(
            textDirection: TextDirection.ltr,
            children: isArabic
                ? [
                    _RatingMetric(restaurant: restaurant, isArabic: isArabic),
                    _VerticalDivider(),
                    Expanded(
                      child: _InfoMetric(
                        assetName: AppAssets.restaurantDeliveryScooterIcon,
                        label: isArabic ? '${restaurant.deliveryFee} ج.م' : 'EGP ${restaurant.deliveryFee}',
                        iconOnRight: true,
                      ),
                    ),
                    _VerticalDivider(),
                    Expanded(
                      child: _InfoMetric(
                        assetName: AppAssets.restaurantWallClockIcon,
                        label: isArabic
                            ? '${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} دقيقة'
                            : '${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} min',
                        iconOnRight: true,
                      ),
                    ),
                  ]
                : [
                    Expanded(
                      child: _InfoMetric(
                        assetName: AppAssets.restaurantWallClockIcon,
                        label: '${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} min',
                        iconOnRight: false,
                      ),
                    ),
                    _VerticalDivider(),
                    Expanded(
                      child: _InfoMetric(
                        assetName: AppAssets.restaurantDeliveryScooterIcon,
                        label: isArabic ? '${restaurant.deliveryFee} ج.م' : 'EGP ${restaurant.deliveryFee}',
                        iconOnRight: false,
                      ),
                    ),
                    _VerticalDivider(),
                    _RatingMetric(restaurant: restaurant, isArabic: isArabic),
                  ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return AppStatusDotLabel(label: label, color: AppColors.success, gap: 4);
  }
}

class _InfoMetric extends StatelessWidget {
  const _InfoMetric({
    required this.assetName,
    required this.label,
    required this.iconOnRight,
  });

  final String assetName;
  final String label;
  final bool iconOnRight;

  @override
  Widget build(BuildContext context) {
    final children = [
      Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.body(context).copyWith(fontSize: 12, height: 1.3),
      ),
      const SizedBox(width: 4),
      _RestaurantIconAsset(assetName: assetName, size: 20),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.ltr,
      children: iconOnRight ? children : children.reversed.toList(),
    );
  }
}

class _RestaurantIconAsset extends StatelessWidget {
  const _RestaurantIconAsset({required this.assetName, required this.size});

  final String assetName;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (assetName.endsWith('.svg')) {
      return AppSvgImage.asset(assetName, width: size, height: size);
    }

    return AppRasterImage.asset(assetName, width: size, height: size);
  }
}

class _DashedVerticalDivider extends StatelessWidget {
  const _DashedVerticalDivider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(1, 20),
      painter: _DashedVerticalDividerPainter(color),
    );
  }
}

class _DashedVerticalDividerPainter extends CustomPainter {
  const _DashedVerticalDividerPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5
      ..strokeCap = StrokeCap.round;
    const dashHeight = 3.0;
    const gap = 2.0;
    var y = 0.0;
    while (y < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, y),
        Offset(size.width / 2, (y + dashHeight).clamp(0, size.height)),
        paint,
      );
      y += dashHeight + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedVerticalDividerPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _RatingMetric extends StatelessWidget {
  const _RatingMetric({required this.restaurant, required this.isArabic});

  final Restaurant restaurant;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => context.push(RouteNames.restaurantRateFor(restaurant.id)),
        borderRadius: const BorderRadius.all(AppRadius.sm),
        child: _InfoMetric(
          assetName: AppAssets.favoriteStarIcon,
          label: '${restaurant.rating.toStringAsFixed(1)} (${restaurant.ratingCount})',
          iconOnRight: isArabic,
        ),
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 0.5, height: 20, color: AppColors.border(context));
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({
    required this.onTap,
    required this.assetName,
    this.mirrorAsset = false,
    this.size = 32,
    this.iconWidth,
    this.iconHeight,
    this.isScrolled = false,
  });

  final String assetName;
  final bool mirrorAsset;
  final VoidCallback onTap;
  final double size;
  final double? iconWidth;
  final double? iconHeight;

  /// When [true], the button has scrolled behind the solid AppBar.
  /// Renders a flat transparent container with a theme-aware icon color
  /// instead of the glass blur effect.
  final bool isScrolled;

  @override
  Widget build(BuildContext context) {
    final icon = Transform.scale(
      scaleX: mirrorAsset ? -1 : 1,
      child: AppRasterImage.asset(
        assetName,
        width: iconWidth,
        height: iconHeight,
        // In scrolled state the icon sits on a solid primary background,
        // so we use AppColors.text (white) to keep it visible.
        // In un-scrolled state the glass button already tints correctly.
        color: isScrolled ? AppColors.onSurface(context) : null,
      ),
    );

    if (isScrolled) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: ShapeDecoration(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Center(child: icon),
        ),
      );
    }

    return LiquidGlassButton(onTap: onTap, size: size, child: icon);
  }
}

class _CouponStrip extends StatelessWidget {
  const _CouponStrip({required this.copy});

  final _RestaurantDetailCopy copy;

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return SizedBox(
      height: 54,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          reverse: isArabic,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          itemCount: 2,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (context, index) => _CouponCard(copy: copy),
        ),
      ),
    );
  }
}

class _CouponCard extends StatelessWidget {
  const _CouponCard({required this.copy});

  final _RestaurantDetailCopy copy;

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    const icon = AppRasterImage.asset(
      AppAssets.restaurantCouponIcon,
      width: 20,
      height: 20,
    );
    final divider = _DashedVerticalDivider(color: AppColors.primary);
    final maxCouponWidth =
        MediaQuery.sizeOf(context).width - (AppSpacing.md * 2);
    final discountText = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxCouponWidth * 0.48),
      child: Text(
        copy.discountSubtitle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: isArabic ? TextAlign.right : TextAlign.left,
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        style: AppTextStyles.caption(context).copyWith(
          color: AppColors.onSurface(context),
          fontSize: 10,
          height: 1.25,
        ),
      ),
    );
    final viewProducts = Text(
      copy.viewProducts,
      style: AppTextStyles.textLinkUnderline(context).copyWith(
        color: AppColors.primary,
        decorationColor: AppColors.primary,
        fontSize: 10,
        height: 1.25,
      ),
    );

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxCouponWidth),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard(context),
          borderRadius: const BorderRadius.all(AppRadius.sm),
          border: Border.all(color: AppColors.primary, width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.ltr,
          children: isArabic
              ? [
                  viewProducts,
                  const SizedBox(width: AppSpacing.sm),
                  discountText,
                  const SizedBox(width: AppSpacing.sm),
                  divider,
                  const SizedBox(width: AppSpacing.sm),
                  icon,
                ]
              : [
                  icon,
                  const SizedBox(width: AppSpacing.sm),
                  divider,
                  const SizedBox(width: AppSpacing.sm),
                  discountText,
                  const SizedBox(width: AppSpacing.sm),
                  viewProducts,
                ],
        ),
      ),
    );
  }
}

class _MenuTabs extends StatelessWidget {
  const _MenuTabs({
    required this.categories,
    required this.selectedIndex,
    required this.onTap,
  });

  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final indexedCategories = List.generate(
      categories.length,
      (index) => (index: index, label: categories[index]),
    );
    final orderedCategories = indexedCategories;

    return Container(
      height: _kTabBarHeight,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border(context), width: 0.5),
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          reverse: isArabic,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          itemCount: orderedCategories.length,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (context, itemIndex) {
            final category = orderedCategories.elementAt(itemIndex);
            return _MenuTab(
              label: category.label,
              selected: category.index == selectedIndex,
              onTap: () => onTap(category.index),
            );
          },
        ),
      ),
    );
  }
}

class _MenuTab extends StatelessWidget {
  const _MenuTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 60),
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption(context).copyWith(
                    fontSize: 12,
                    height: 1.3,
                    color: selected
                        ? AppColors.onSurface(context)
                        : AppColors.paragraph(context),
                    fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 1.5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.onSurface(context)
                        : AppColors.transparent,
                    borderRadius: const BorderRadius.vertical(
                      top: AppRadius.full,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuSections extends StatelessWidget {
  const _MenuSections({required this.sections, required this.sectionKeys});

  final List<MenuCategory> sections;
  final List<GlobalKey> sectionKeys;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < sections.length; i++) ...[
          if (i > 0) const SizedBox(height: 24),
          _MenuSection(key: sectionKeys[i], section: sections[i]),
        ],
      ],
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.section, super.key});

  final MenuCategory section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.name,
          style: AppTextStyles.heading4(context).copyWith(
            fontSize: 15,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
        _SectionProductGrid(items: section.items),
      ],
    );
  }
}

class _SectionProductGrid extends StatelessWidget {
  const _SectionProductGrid({required this.items});

  final List<MenuItem> items;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];

    for (var i = 0; i < items.length; i += 2) {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                height: 164,
                child: MenuItemTile(item: items[i]),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: i + 1 < items.length
                  ? SizedBox(
                      height: 164,
                      child: MenuItemTile(item: items[i + 1]),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          rows[i],
        ],
      ],
    );
  }
}

class _RestaurantDetailCopy {
  const _RestaurantDetailCopy({
    required this.title,
    required this.available,
    required this.discountSubtitle,
    required this.viewProducts,
  });

  final String title;
  final String available;
  final String discountSubtitle;
  final String viewProducts;

  static _RestaurantDetailCopy of(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _RestaurantDetailCopy(
      title: l10n.restaurantDetailsTitle,
      available: l10n.serviceAvailable,
      discountSubtitle: l10n.restaurantDiscountSubtitle,
      viewProducts: l10n.restaurantViewProducts,
    );
  }
}

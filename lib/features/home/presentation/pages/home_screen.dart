import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/app_spacing.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/app_media.dart';
import 'package:food_user_app/core/widgets/app_search_field.dart';
import 'package:food_user_app/features/profile/presentation/controllers/saved_addresses_scope.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/home/presentation/widgets/banner_slider.dart';
import 'package:food_user_app/features/home/presentation/cubit/home_cubits.dart';
import 'package:food_user_app/features/home/presentation/widgets/category_grid.dart';
import 'package:food_user_app/features/restaurant/presentation/widgets/restaurant_card.dart';
import 'package:food_user_app/core/di/injection_container.dart';
import 'package:food_user_app/features/restaurant/domain/entities/restaurant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final addressesController = SavedAddressesScope.of(context);
    if (!addressesController.hasLoaded && !addressesController.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        addressesController.loadAddressesIfNeeded();
      });
    }
    final copy = _HomeCopy.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider<SectionsCubit>(
          create: (context) => sl<SectionsCubit>()..fetchSections(),
        ),
        BlocProvider<SpotlightsCubit>(
          create: (context) => sl<SpotlightsCubit>()..fetchSpotlights(),
        ),
      ],
      child: Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _HomeHeader(copy: copy)),
          SliverPadding(
            padding: const EdgeInsets.only(top: 22, bottom: AppSpacing.lg),
            sliver: SliverList.list(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: CategoryGrid(),
                ),
                const SizedBox(height: 20),
                const BannerSlider(),
                const SizedBox(height: 18),
                const SizedBox(height: 10),
                const _SpotlightsSections(),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.copy});

  final _HomeCopy copy;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return Container(
      height: 148 + topPadding,
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
          PositionedDirectional(
            top: 16 + topPadding,
            start: AppSpacing.md,
            end: AppSpacing.md,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: _LocationRow(copy: copy),
            ),
          ),
          PositionedDirectional(
            start: AppSpacing.md,
            end: AppSpacing.md,
            bottom: 25,
            child: _SearchEntry(copy: copy),
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
}

// Returns true when the string contains Arabic/Arabic-Extended characters.
bool _containsArabic(String text) =>
    RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]').hasMatch(text);

class _LocationRow extends StatelessWidget {
  const _LocationRow({required this.copy});

  final _HomeCopy copy;

  @override
  Widget build(BuildContext context) {
    final isAddressArabic = _containsArabic(copy.address);
    final addressTextDirection =
        isAddressArabic ? TextDirection.rtl : TextDirection.ltr;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push(RouteNames.addressBook),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            copy.deliveryTo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            style: AppTextStyles.caption(context).copyWith(
              color: AppColors.text.withValues(alpha: 0.72),
              fontSize: 10,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on_rounded,
                size: 16,
                color: AppColors.text,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  copy.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  textDirection: addressTextDirection,
                  style: AppTextStyles.body(
                    context,
                  ).copyWith(color: AppColors.text, fontSize: 12, height: 1.3),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16,
                color: AppColors.text,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchEntry extends StatefulWidget {
  const _SearchEntry({required this.copy});

  final _HomeCopy copy;

  @override
  State<_SearchEntry> createState() => _SearchEntryState();
}

class _SearchEntryState extends State<_SearchEntry> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceCard(context),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        onTap: () => context.push(RouteNames.search),
        child: AbsorbPointer(
          child: AppSearchField(
            controller: _controller,
            hint: widget.copy.searchHint,
            height: 40,
            hintColor: AppColors.inputHintStrong,
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.heading4(
          context,
        ).copyWith(fontSize: 15, height: 1.4),
      ),
    );
  }
}

class _SpotlightsSections extends StatelessWidget {
  const _SpotlightsSections();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotlightsCubit, SpotlightsState>(
      builder: (context, state) {
        if (state is SpotlightsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SpotlightsError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: AppColors.error),
            ),
          );
        } else if (state is SpotlightsLoaded) {
          final spotlights = state.spotlights;
          if (spotlights.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: spotlights.map((spotlight) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: _SectionHeader(title: spotlight.name)),
                        if (spotlight.hasMore)
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              AppLocalizations.of(context)!.seeAll,
                              style: AppTextStyles.caption(context).copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 209,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      scrollDirection: Axis.horizontal,
                      itemCount: spotlight.stores.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final store = spotlight.stores[index];
                        final restaurant = Restaurant(
                          id: store.id.toString(),
                          name: store.name,
                          cuisineType: store.tags.isNotEmpty ? store.tags.first.name : '',
                          coverImageUrl: store.cover ?? '',
                          logoUrl: store.logo ?? '',
                          rating: store.ratingAvg ?? 0.0,
                          ratingCount: store.ratingCount ?? 0,
                          deliveryTimeMin: store.prepTimeFrom ?? 0,
                          deliveryTimeMax: store.prepTimeTo ?? 0,
                          deliveryFee: 0.0,
                          isFavorited: false,
                          isMajor: store.isMajor,
                          availability: store.availability,
                          tags: store.tags.map((t) => t.name).toList(),
                        );
                        return RestaurantCard(restaurant: restaurant);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }).toList(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _HomeCopy {
  const _HomeCopy({
    required this.deliveryTo,
    required this.address,
    required this.searchHint,
    required this.bannerEyebrow,
    required this.bannerTitle,
    required this.orderNow,
    required this.missedOffersTitle,
    required this.mostOrderedTitle,
    required this.available,
    required this.closed,
  });

  final String deliveryTo;
  final String address;
  final String searchHint;
  final String bannerEyebrow;
  final String bannerTitle;
  final String orderNow;
  final String missedOffersTitle;
  final String mostOrderedTitle;
  final String available;
  final String closed;

  static _HomeCopy of(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final l10n = AppLocalizations.of(context)!;
    final selectedAddressObj = SavedAddressesScope.of(context).selectedAddress;
    final selectedAddress = (selectedAddressObj?.fullAddress != null && selectedAddressObj!.fullAddress!.trim().isNotEmpty)
        ? selectedAddressObj.fullAddress!.trim()
        : selectedAddressObj?.shortLocation(locale);

    return _HomeCopy(
      deliveryTo: l10n.homeDeliveryTo,
      address: selectedAddress ?? l10n.selectDeliveryAddress,
      searchHint: l10n.serviceSearchHint,
      bannerEyebrow: l10n.homeBannerEyebrow,
      bannerTitle: l10n.homeBannerTitle,
      orderNow: l10n.homeOrderNow,
      missedOffersTitle: l10n.homeMissedOffersTitle,
      mostOrderedTitle: l10n.homeMostOrderedTitle,
      available: l10n.serviceAvailable,
      closed: l10n.serviceClosed,
    );
  }
}

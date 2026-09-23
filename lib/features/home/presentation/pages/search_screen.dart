import 'package:food_user_app/core/widgets/shared_store_list_tile.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/app_radius.dart';
import 'package:food_user_app/core/theme/app_spacing.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/app_media.dart';
import 'package:food_user_app/core/widgets/app_search_field.dart';

import 'package:food_user_app/features/cart/domain/entities/cart_item.dart';

import 'package:food_user_app/features/service_listing/presentation/models/service_listing_config.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:food_user_app/features/search/presentation/cubit/search_state.dart';

import 'package:food_user_app/features/home/domain/entities/tag.dart';
import 'package:food_user_app/features/search/domain/entities/search_keyword.dart';
import 'package:food_user_app/features/search/domain/entities/search_log.dart';
import 'package:food_user_app/features/restaurant/domain/entities/restaurant.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_item.dart';
import 'package:food_user_app/core/widgets/empty_state_widget.dart';
import 'package:food_user_app/features/market/presentation/widgets/hypermarket_mini_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final ScrollController _scrollController;
  Timer? _debounceTimer;

  ServiceCategoryData? _selectedCategory;
  final Set<ServiceFilterId> _selectedFilters = {};

  @override
  void initState() {
    super.initState();
    // Explicitly reset global filter states to ensure clean entry
    context.read<SearchCubit>().resetFilters();
    _controller = TextEditingController()..addListener(_onSearchChanged);
    _focusNode = FocusNode();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller
      ..removeListener(_onSearchChanged)
      ..dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _resetScroll() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0.0);
    }
  }

  void _onSearchChanged() {
    setState(() {});
    _resetScroll();
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<SearchCubit>().search(_controller.text.trim());
      }
    });
  }

  void _onTokenTap(String token) {
    _controller.text = token;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: token.length),
    );
    if (token.trim().isNotEmpty) {
      context.read<SearchCubit>().addSearchLog(token.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final query = _controller.text.trim();
    final scope = _selectedCategory?.label;
    final searchState = context.watch<SearchCubit>().state;
    final selectedTagId = context.watch<SearchCubit>().selectedTagId;
    final hasActiveFilters = _selectedFilters.isNotEmpty;
    final showFilters =
        scope != null ||
        query.isNotEmpty ||
        selectedTagId != null ||
        hasActiveFilters;

    final keywords = searchState.maybeWhen(
      initialDataLoaded: (_, kw, _, _) => kw,
      orElse: () => const <SearchKeyword>[],
    );

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // ── Fixed Top Controls Section ───────────────────────────────────
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  AppSpacing.md,
                  20,
                  AppSpacing.md,
                  16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SearchHeader(title: l10n.searchTitle),
                    const SizedBox(height: 24),
                    AppSearchField(
                      controller: _controller,
                      focusNode: _focusNode,
                      hint: l10n.serviceSearchHint,
                      iconAsset: AppAssets.serviceSearchIcon,
                      onSubmitted: (val) {
                        if (val.trim().isNotEmpty) {
                          context.read<SearchCubit>().addSearchLog(val.trim());
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _CategoryStrip(
                      tags: context.read<SearchCubit>().tags,
                      selectedTagId: context.read<SearchCubit>().selectedTagId,
                      onSelected: (tag) {
                        _resetScroll();
                        context.read<SearchCubit>().toggleTag(
                          tag.id,
                          _controller.text.trim(),
                        );
                      },
                    ),
                    if (showFilters) ...[
                      const SizedBox(height: 16),
                      _FilterStrip(
                        filters: ServiceListingConfig.topFilters(l10n),
                        selectedFilters: _selectedFilters,
                        onToggle: (filter) {
                          setState(() {
                            _selectedFilters.contains(filter)
                                ? _selectedFilters.remove(filter)
                                : _selectedFilters.add(filter);
                          });
                          _resetScroll();

                          // Map to SearchCubit
                          final hasOffers =
                              _selectedFilters.contains(ServiceFilterId.offers)
                              ? 1
                              : null;
                          final fastPrep =
                              _selectedFilters.contains(
                                ServiceFilterId.fastDelivery,
                              )
                              ? 1
                              : null;
                          final topRated =
                              _selectedFilters.contains(
                                ServiceFilterId.topRated,
                              )
                              ? 1
                              : null;

                          final cubit = context.read<SearchCubit>();
                          cubit.setFilters(
                            fastPrep: fastPrep,
                            topRated: topRated,
                            hasOffers: hasOffers,
                          );
                          cubit.search(_controller.text.trim());
                        },
                      ),
                    ],
                  ],
                ),
              ),

              // ── Scrollable Results Section ───────────────────────────────────
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    final isLoading = state.maybeWhen(
                      loading: () => true,
                      orElse: () => false,
                    );
                    final isLoaded = state.maybeWhen(
                      loaded: (_) => true,
                      orElse: () => false,
                    );

                    return state.maybeWhen(
                      error: (msg) => Center(
                        child: Text(msg, style: AppTextStyles.body(context)),
                      ),
                      initialDataLoaded: (history, kw, tags, majorStores) =>
                          _buildSearchResults(
                            context,
                            query: query,
                            scope: scope,
                            history: history,
                            keywords: kw,
                            restaurants: const [],
                            majorStores: query.isNotEmpty
                                ? const []
                                : majorStores,
                            items: const [],
                            selectedTagId: selectedTagId,
                            isLoaded: isLoaded,
                            isLoading: isLoading,
                          ),
                      loaded: (result) {
                        final majorStores = result.restaurants
                            .where((r) => r.isMajor == true)
                            .toList();
                        final normalStores = result.restaurants
                            .where((r) => r.isMajor == false)
                            .toList();
                        return _buildSearchResults(
                          context,
                          query: query,
                          scope: scope,
                          history: const [],
                          keywords: keywords,
                          restaurants: normalStores,
                          majorStores: majorStores,
                          items: result.items,
                          selectedTagId: selectedTagId,
                          isRandom: result.isRandom,
                          isLoaded: isLoaded,
                          isLoading: isLoading,
                        );
                      },
                      orElse: () => _buildSearchResults(
                        context,
                        query: query,
                        scope: scope,
                        history: const [],
                        keywords: keywords,
                        restaurants: const [],
                        majorStores: const [],
                        items: const [],
                        selectedTagId: selectedTagId,
                        isLoaded: isLoaded,
                        isLoading: isLoading,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClearConfirmDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.searchClearAll),
        content: Text(l10n.searchClearHistoryConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<SearchCubit>().clearSearchLogs();
            },
            child: Text(
              l10n.clear,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(
    BuildContext context, {
    required String query,
    required String? scope,
    required List<SearchLog> history,
    required List<SearchKeyword> keywords,
    required List<Restaurant> restaurants,
    required List<Restaurant> majorStores,
    required List<MenuItem> items,
    int? selectedTagId,
    bool isRandom = false,
    bool isLoaded = false,
    bool isLoading = false,
  }) {
    final l10n = AppLocalizations.of(context)!;

    final displayedLargeStores = majorStores
        .map(_mapToServicePlaceData)
        .toList();
    final displayedStores = restaurants.map(_mapToServicePlaceData).toList();

    // Map products directly since backend filters them
    final filteredProducts = items.map(_mapToSearchResult).toList();

    final hasActiveFilters = _selectedFilters.isNotEmpty;
    final showFilters =
        scope != null ||
        query.isNotEmpty ||
        selectedTagId != null ||
        hasActiveFilters;
    // We also consider noResults if API returned isRandom = true since those are fallback suggestions
    final noResults =
        (query.isNotEmpty || selectedTagId != null || hasActiveFilters) &&
        isLoaded &&
        !isLoading &&
        displayedLargeStores.isEmpty &&
        displayedStores.isEmpty &&
        filteredProducts.isEmpty &&
        !isRandom;

    return CustomScrollView(
      controller: _scrollController,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverPadding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            40,
          ),
          sliver: SliverList.list(
            children: [
              if (majorStores.isNotEmpty) ...[
                _SectionTitle(title: l10n.serviceLargeStores),
                const SizedBox(height: 12),
                _LargeStoreRow(items: majorStores),
                const SizedBox(height: 22),
              ],
              if (!showFilters) ...[
                if (history.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SectionTitle(title: l10n.searchRecentTitle),
                      TextButton(
                        onPressed: () => _showClearConfirmDialog(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(40, 24),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          l10n.searchClearAll,
                          style: AppTextStyles.caption(
                            context,
                          ).copyWith(color: AppColors.primary, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _RecentSearchesWrap(history: history, onTap: _onTokenTap),
                  const SizedBox(height: 24),
                ],
                if (keywords.isNotEmpty) ...[
                  _SectionTitle(title: l10n.searchMostSearchedTitle),
                  const SizedBox(height: 12),
                  _MostSearchedTokens(
                    tokens: keywords.map((k) => k.term).toList(),
                    onTap: _onTokenTap,
                  ),
                ],
              ] else ...[
                if (isLoading &&
                    displayedStores.isEmpty &&
                    filteredProducts.isEmpty) ...[
                  const SizedBox(height: 48),
                  const Center(child: CircularProgressIndicator()),
                ] else if (noResults) ...[
                  const SizedBox(height: 48),
                  const EmptyStateWidget(imageWidth: 100, imageHeight: 100),
                ] else ...[
                  if (displayedStores.isNotEmpty) ...[
                    _SectionTitle(title: l10n.serviceAllPlaces),
                    const SizedBox(height: 12),
                    _PlaceList(items: displayedStores),
                    const SizedBox(height: 22),
                  ],
                  if (filteredProducts.isNotEmpty) ...[
                    _SectionTitle(title: l10n.searchResultsTitle),
                    const SizedBox(height: 12),
                    ...filteredProducts.map(
                      (r) => Padding(
                        padding: const EdgeInsetsDirectional.only(bottom: 12),
                        child: _ResultCard(result: r),
                      ),
                    ),
                  ],
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }

  _SearchResult _mapToSearchResult(MenuItem item) {
    return _SearchResult(
      id: item.id,
      title: item.name,
      subtitle: item.description,
      rating: '4.8',
      deliveryTime: '30 min',
      price: '${item.price.toStringAsFixed(2)} EGP',
      priceValue: item.price.toDouble(),
      imageAsset: item.imageUrl,
      isRestaurant: false,
      keywords: const [],
    );
  }

  ServicePlaceData _mapToServicePlaceData(Restaurant restaurant) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return ServicePlaceData.restaurant(
      id: restaurant.id,
      name: restaurant.name,
      subtitle: restaurant.cuisineType,
      time: isArabic
          ? '${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} دقيقة'
          : '${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} min',
      imageAsset: restaurant.coverImageUrl,
      rating: restaurant.rating.toStringAsFixed(1),
      hasOffer: false,
      fastDelivery: restaurant.deliveryTimeMax <= 30,
      topRated: restaurant.rating >= 4.5,
      isMajor: restaurant.isMajor,
    );
  }
}

class _SearchHeader extends StatelessWidget {
  const _SearchHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => context.pop(),
          style: IconButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: const Size(28, 28),
            padding: EdgeInsets.zero,
          ),
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppColors.onSurface(context),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.heading4(
            context,
          ).copyWith(fontSize: 16, height: 1.4),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

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

class _CategoryStrip extends StatelessWidget {
  const _CategoryStrip({
    required this.tags,
    required this.selectedTagId,
    required this.onSelected,
  });

  final List<Tag> tags;
  final int? selectedTagId;
  final ValueChanged<Tag> onSelected;

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 90,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final tag = tags[index];
          return _CategoryChip(
            tag: tag,
            selected: selectedTagId == tag.id,
            onTap: () => onSelected(tag),
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.tag,
    required this.selected,
    required this.onTap,
  });

  final Tag tag;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.surfaceCard(context),
              borderRadius: const BorderRadius.all(AppRadius.full),
              border: selected
                  ? Border.all(color: AppColors.primary, width: 1)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: AppColors.onSurface(context).withValues(alpha: 0.08),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(7),
              child: tag.image != null
                  ? _buildImage(
                      tag.image!,
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    )
                  : Icon(
                      Icons.category,
                      color: AppColors.paragraph(context),
                      size: 22,
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            tag.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption(context).copyWith(
              color: AppColors.onSurface(context),
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterStrip extends StatelessWidget {
  const _FilterStrip({
    required this.filters,
    required this.selectedFilters,
    required this.onToggle,
  });

  final List<ServiceFilterData> filters;
  final Set<ServiceFilterId> selectedFilters;
  final ValueChanged<ServiceFilterId> onToggle;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < filters.length; i++) ...[
            _FilterChip(
              filter: filters[i],
              selected: selectedFilters.contains(filters[i].id),
              onTap: () => onToggle(filters[i].id),
            ),
            if (i != filters.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.filter,
    required this.selected,
    required this.onTap,
  });

  final ServiceFilterData filter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(AppRadius.sm),
      child: Container(
        height: 32,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surfaceCard(context),
          borderRadius: const BorderRadius.all(AppRadius.sm),
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface(context).withValues(alpha: 0.08),
              blurRadius: 2,
            ),
          ],
        ),
        child: Text(
          filter.label,
          style: AppTextStyles.caption(context).copyWith(
            color: selected ? AppColors.text : AppColors.paragraph(context),
            fontSize: 10,
            height: 1.25,
          ),
        ),
      ),
    );
  }
}

class _LargeStoreRow extends StatelessWidget {
  const _LargeStoreRow({required this.items});

  final List<Restaurant> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 106,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return HypermarketMiniCard(
            market: item,
            onTap: () {
              final storeId = item.id;
              debugPrint(
                '🛠️ Tapped Store: ${item.name} | isMajor: ${item.isMajor}',
              );
              if (item.isMajor == true) {
                context.push(RouteNames.marketDetailsFor(storeId));
              } else {
                context.push(RouteNames.restaurantDetailFor(storeId));
              }
            },
          );
        },
      ),
    );
  }
}

class _MostSearchedTokens extends StatelessWidget {
  const _MostSearchedTokens({required this.tokens, required this.onTap});

  final List<String> tokens;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: tokens.map((token) {
        return _SearchToken(label: token, onTap: () => onTap(token));
      }).toList(),
    );
  }
}

class _RecentSearchesWrap extends StatelessWidget {
  const _RecentSearchesWrap({required this.history, required this.onTap});

  final List<SearchLog> history;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: history.map((log) {
        return _RecentSearchItem(
          log: log,
          onTap: () => onTap(log.term),
          onDelete: () => context.read<SearchCubit>().deleteSearchLog(log.id),
        );
      }).toList(),
    );
  }
}

class _RecentSearchItem extends StatelessWidget {
  const _RecentSearchItem({
    required this.log,
    required this.onTap,
    required this.onDelete,
  });

  final SearchLog log;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 6, 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        borderRadius: const BorderRadius.all(AppRadius.sm),
        border: Border.all(color: AppColors.border(context), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.history_rounded,
                  size: 14,
                  color: AppColors.paragraph(context),
                ),
                const SizedBox(width: 6),
                Text(
                  log.term,
                  style: AppTextStyles.caption(context).copyWith(
                    color: AppColors.onSurface(context),
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onDelete,
            borderRadius: const BorderRadius.all(AppRadius.full),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Icon(
                Icons.close_rounded,
                size: 14,
                color: AppColors.paragraph(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchToken extends StatelessWidget {
  const _SearchToken({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(AppRadius.sm),
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 6, 10, 6),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard(context),
          borderRadius: const BorderRadius.all(AppRadius.sm),
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface(context).withValues(alpha: 0.08),
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.refresh_rounded,
              size: 14,
              color: AppColors.paragraph(context),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.caption(context).copyWith(
                color: AppColors.onSurface(context),
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result});

  final _SearchResult result;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceCard(context),
      borderRadius: const BorderRadius.all(AppRadius.md),
      child: InkWell(
        borderRadius: const BorderRadius.all(AppRadius.md),
        onTap: () => _openSearchResult(context, result),
        child: Container(
          padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(AppRadius.md),
            border: Border.all(color: AppColors.border(context), width: 0.5),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(AppRadius.sm),
                child: _buildImage(
                  result.imageAsset,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body(
                        context,
                      ).copyWith(fontSize: 13, height: 1.3),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      result.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption(
                        context,
                      ).copyWith(fontSize: 10, height: 1.25),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        AppSvgImage.asset(
                          AppAssets.serviceStarIcon,
                          width: 14,
                          height: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          result.rating,
                          style: AppTextStyles.caption(
                            context,
                          ).copyWith(fontSize: 10),
                        ),
                        const SizedBox(width: 10),
                        AppSvgImage.asset(
                          AppAssets.favoriteTimeIcon,
                          width: 14,
                          height: 14,
                          color: AppColors.paragraph(context),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          result.deliveryTime,
                          style: AppTextStyles.caption(
                            context,
                          ).copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                result.price,
                style: AppTextStyles.body(
                  context,
                ).copyWith(fontSize: 13, height: 1.25),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _openSearchResult(BuildContext context, _SearchResult result) {
  if (result.isRestaurant) {
    context.push(RouteNames.restaurantDetailFor(result.id));
    return;
  }
  context.push(
    RouteNames.productDetails,
    extra: CartItem(
      id: result.id,
      name: result.title,
      description: result.subtitle,
      price: result.priceValue,
      imageAsset: result.imageAsset,
    ),
  );
}

class _SearchGroup {
  const _SearchGroup({
    required this.title,
    this.items = const [],
    this.largeItems = const [],
  });

  final String title;
  final List<ServicePlaceData> items;
  final List<ServicePlaceData> largeItems;
}

class _SearchCopy {
  const _SearchCopy({
    required this.groups,
    required this.mostSearchedTokens,
    required this.allResults,
  });

  final List<_SearchGroup> groups;
  final List<String> mostSearchedTokens;
  final List<_SearchResult> allResults;

  List<_SearchResult> results(String query) {
    final normalizedQuery = query.toLowerCase();
    return allResults.where((result) {
      return result.title.toLowerCase().contains(normalizedQuery) ||
          result.subtitle.toLowerCase().contains(normalizedQuery) ||
          result.keywords.any(
            (keyword) => keyword.toLowerCase().contains(normalizedQuery),
          );
    }).toList();
  }

  static _SearchCopy of(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final kira = ServicePlaceData.restaurant(
      name: l10n.serviceRestaurantKira,
      subtitle: l10n.serviceRestaurantDescription,
      time: l10n.serviceDeliveryTimeRange,
      imageAsset: AppAssets.homeRestaurantCover,
      rating: '4.6',
      hasOffer: true,
    );
    final azAlSham = ServicePlaceData.restaurant(
      name: l10n.serviceRestaurantAzAlSham,
      subtitle: l10n.serviceRestaurantDescription,
      time: l10n.serviceDeliveryTime25To40,
      imageAsset: AppAssets.favoriteRestaurantAzAlSham,
      rating: '4.8',
      fastDelivery: true,
    );
    final captain = ServicePlaceData.store(
      name: l10n.serviceStoreCaptain,
      time: l10n.serviceDeliveryTimeRange,
      imageAsset: AppAssets.searchCaptain,
      rating: '4.5',
      hasOffer: true,
    );
    final fathallah = ServicePlaceData.store(
      name: l10n.serviceStoreFathallah,
      time: l10n.serviceDeliveryTimeRange,
      imageAsset: AppAssets.searchFathallah,
      rating: '4.6',
      fastDelivery: true,
    );
    final beauty = ServicePlaceData.store(
      name: l10n.serviceCategoryPerfumeBeauty,
      time: l10n.serviceDeliveryTime35To50,
      imageAsset: AppAssets.serviceStoresBeauty,
      rating: '4.5',
      hasOffer: true,
    );
    final flowers = ServicePlaceData.store(
      name: l10n.serviceCategoryFlowers,
      time: l10n.serviceDeliveryTime25To40,
      imageAsset: AppAssets.serviceStoresFlowers,
      rating: '4.7',
      fastDelivery: true,
    );
    final rimasLand = ServicePlaceData.pickup(
      name: l10n.serviceStoreRimasLand,
      time: l10n.serviceDeliveryTimeRange,
      imageAsset: AppAssets.servicePickupRimas,
      rating: '4.5',
      hasOffer: true,
      topRated: true,
    );
    final taheraFry = ServicePlaceData.pickup(
      name: l10n.serviceStoreTaheraFry,
      time: l10n.serviceDeliveryTimeRange,
      imageAsset: AppAssets.servicePickupTahera,
      rating: '4.5',
      hasOffer: true,
      topRated: true,
      fastDelivery: true,
    );
    final familyMarket = ServicePlaceData.pickup(
      name: l10n.serviceStoreFamilyMarket,
      time: l10n.serviceDeliveryTimeRange,
      imageAsset: AppAssets.servicePickupFamily,
      rating: '4.5',
      topRated: true,
    );
    final captainMarket = ServicePlaceData.pickup(
      name: l10n.serviceCaptainMarket,
      time: l10n.serviceDeliveryTimeRange,
      imageAsset: AppAssets.servicePickupCaptain,
      rating: '4.5',
      fastDelivery: true,
    );

    return _SearchCopy(
      groups: [
        _SearchGroup(
          title: l10n.serviceCategoryDesserts,
          largeItems: [fathallah, kira],
          items: [kira, azAlSham, rimasLand, kira, azAlSham],
        ),
        _SearchGroup(
          title: l10n.serviceCategoryGrills,
          items: [azAlSham, kira, taheraFry, azAlSham, kira],
        ),
        _SearchGroup(
          title: l10n.serviceCategoryPizza,
          items: [kira, azAlSham, familyMarket, kira, azAlSham, taheraFry],
        ),
        _SearchGroup(
          title: l10n.serviceCategoryFastFood,
          items: [
            taheraFry,
            kira,
            azAlSham,
            captainMarket,
            taheraFry,
            kira,
            taheraFry,
            kira,
            azAlSham,
            captainMarket,
            taheraFry,
            kira,
            taheraFry,
            kira,
            azAlSham,
            captainMarket,
            taheraFry,
            kira,
            taheraFry,
            kira,
          ],
        ),
        _SearchGroup(
          title: l10n.serviceCategoryBurger,
          items: [azAlSham, kira, kira, azAlSham, familyMarket],
        ),
        _SearchGroup(
          title: l10n.serviceCategoryShawarma,
          items: [kira, azAlSham, taheraFry, kira, azAlSham],
        ),
        _SearchGroup(
          title: l10n.serviceCategorySupermarket,
          largeItems: [
            captain,
            fathallah,
            captain,
            fathallah,
            captain,
            fathallah,
            captain,
            fathallah,
          ],
          items: [
            captain,
            fathallah,
            familyMarket,
            captainMarket,
            captain,
            captain,
            fathallah,
            familyMarket,
            captainMarket,
            captain,
            captain,
            fathallah,
            familyMarket,
            captainMarket,
            captain,
            captain,
            fathallah,
            familyMarket,
            captainMarket,
            captain,
          ],
        ),
        _SearchGroup(
          title: l10n.serviceCategorySnacks,
          items: [captain, fathallah, rimasLand, taheraFry, captain],
        ),
        _SearchGroup(
          title: l10n.serviceCategoryDairy,
          largeItems: [fathallah],
          items: [fathallah, captain, familyMarket, fathallah, captain],
        ),
        _SearchGroup(
          title: l10n.serviceCategoryFruitsVegetables,
          largeItems: [captain, fathallah],
          items: [captain, fathallah, captain, fathallah, familyMarket],
        ),
        _SearchGroup(
          title: l10n.serviceCategoryRoasters,
          items: [fathallah, captain, fathallah, captain, captainMarket],
        ),
        _SearchGroup(
          title: l10n.serviceCategoryPerfumeBeauty,
          items: [beauty, flowers, beauty, flowers, beauty],
        ),
        _SearchGroup(
          title: l10n.serviceCategoryFlowers,
          items: [flowers, beauty, rimasLand, flowers, beauty],
        ),
      ],
      mostSearchedTokens: [
        l10n.searchMostSearchedDesserts,
        l10n.searchMostSearchedFalafel,
        l10n.searchMostSearchedPizza,
        l10n.searchMostSearchedNuts,
        l10n.searchMostSearchedPepsi,
        l10n.searchMostSearchedJuice,
        l10n.searchMostSearchedCheese,
      ],
      allResults: [
        _SearchResult(
          id: 'az-al-sham',
          title: l10n.serviceRestaurantAzAlSham,
          subtitle: l10n.serviceRestaurantDescription,
          rating: l10n.orderCourierRating,
          deliveryTime: l10n.serviceDeliveryTimeRange,
          price: l10n.cartPrice("190"),
          priceValue: 190.0,
          imageAsset: AppAssets.favoriteRestaurantAzAlSham,
          isRestaurant: true,
          keywords: [
            l10n.searchMostSearchedAzAlSham,
            l10n.serviceCategoryShawarma,
            l10n.serviceCategoryPizza,
            l10n.homeCategoryRestaurants,
          ],
        ),
        _SearchResult(
          id: 'burger-fries',
          title: l10n.searchResultBurgerFriesTitle,
          subtitle: l10n.serviceRestaurantAzAlSham,
          rating: l10n.orderCourierRating,
          deliveryTime: l10n.serviceDeliveryTimeRange,
          price: l10n.cartPrice("190"),
          priceValue: 190.0,
          imageAsset: AppAssets.productBurgerCombo,
          isRestaurant: false,
          keywords: [
            l10n.serviceCategoryBurger,
            l10n.searchResultBurgerFriesTitle,
            l10n.serviceFilterOffers,
          ],
        ),
        _SearchResult(
          id: 'falafel-breakfast',
          title: l10n.searchResultFalafelTitle,
          subtitle: l10n.searchResultFalafelSubtitle,
          rating: '4.3',
          deliveryTime: l10n.favoriteDeliveryTime,
          price: l10n.searchResultFalafelPrice,
          priceValue: 45.0,
          imageAsset: AppAssets.cartProductImage,
          isRestaurant: false,
          keywords: [
            l10n.searchResultFalafelKeywordBeans,
            l10n.searchRecentFalafel,
            l10n.searchCravingBreakfast,
          ],
        ),
      ],
    );
  }
}

class _SearchResult {
  const _SearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.deliveryTime,
    required this.price,
    required this.priceValue,
    required this.imageAsset,
    required this.isRestaurant,
    required this.keywords,
  });

  final String id;
  final String title;
  final String subtitle;
  final String rating;
  final String deliveryTime;
  final String price;
  final double priceValue;
  final String imageAsset;
  final bool isRestaurant;
  final List<String> keywords;
}

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

class _PlaceList extends StatelessWidget {
  const _PlaceList({required this.items});

  final List<ServicePlaceData> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          SharedStoreListTile(item: items[i]),
          if (i != items.length - 1)
            Divider(
              height: 24,
              thickness: 0.5,
              color: AppColors.border(context),
            ),
        ],
      ],
    );
  }
}

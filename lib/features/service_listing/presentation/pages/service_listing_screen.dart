import 'package:food_user_app/core/widgets/shared_store_list_tile.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/app_radius.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/app_media.dart';
import 'package:food_user_app/core/widgets/app_search_field.dart';
import 'package:food_user_app/features/service_listing/presentation/models/service_listing_config.dart';
import 'package:food_user_app/features/service_listing/presentation/models/service_listing_type.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:food_user_app/core/widgets/empty_state_widget.dart';
import 'package:food_user_app/features/home/presentation/cubit/home_cubits.dart';
import 'package:food_user_app/features/home/domain/entities/tag.dart'
    as entity_tag;
import 'package:food_user_app/features/restaurant/domain/entities/restaurant.dart';
import 'package:food_user_app/features/market/presentation/widgets/hypermarket_mini_card.dart';
import 'package:food_user_app/core/router/route_names.dart';

class ServiceListingScreen extends StatefulWidget {
  const ServiceListingScreen({
    required this.type,
    this.sectionId = 1,
    super.key,
  });

  final ServiceListingType type;
  final int sectionId;

  @override
  State<ServiceListingScreen> createState() => _ServiceListingScreenState();
}

class _ServiceListingScreenState extends State<ServiceListingScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  entity_tag.Tag? _selectedTag;
  final Set<ServiceFilterId> _selectedFilters = {};

  @override
  void initState() {
    super.initState();
    context.read<TagsCubit>().fetchTags(sectionId: widget.sectionId);
    _fetchFilteredStores();
  }

  void _fetchFilteredStores() {
    final hasOffers = _selectedFilters.contains(ServiceFilterId.offers)
        ? 1
        : null;
    final fastPrep = _selectedFilters.contains(ServiceFilterId.fastDelivery)
        ? 1
        : null;
    final topRated = _selectedFilters.contains(ServiceFilterId.topRated)
        ? 1
        : null;

    context.read<StoresCubit>().fetchStores(
      sectionId: widget.sectionId,
      search: _searchController.text.isNotEmpty ? _searchController.text : null,
      tagIds: _selectedTag != null ? [_selectedTag!.id] : null,
      fastPrep: fastPrep,
      topRated: topRated,
      hasOffers: hasOffers,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _resetScroll() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final config = ServiceListingConfig.of(l10n, widget.type);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: SafeArea(
        bottom: false,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              // ── Fixed Top Header Section ─────────────────────────────────────
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ListingHeader(title: config.title),
                    const SizedBox(height: 24),
                    _ListingSearchBox(
                      controller: _searchController,
                      hint: config.searchHint,
                      onChanged: (val) {
                        _fetchFilteredStores();
                        _resetScroll();
                      },
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<TagsCubit, TagsState>(
                      builder: (context, tagsState) {
                        if (tagsState is TagsLoading) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (tagsState is TagsLoaded &&
                            tagsState.tags.isNotEmpty) {
                          return _ServiceCategoryStrip(
                            categories: tagsState.tags,
                            selectedCategory: _selectedTag,
                            onSelected: (cat) {
                              setState(() {
                                if (_selectedTag?.id == cat.id) {
                                  _selectedTag = null; // deselect
                                } else {
                                  _selectedTag = cat;
                                }
                              });
                              _fetchFilteredStores();
                              _resetScroll();
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    if (config.filters.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      // filters
                      _ServiceFilterStrip(
                        filters: config.filters,
                        selectedFilters: _selectedFilters,
                        onToggle: (filter) {
                          setState(() {
                            _selectedFilters.contains(filter)
                                ? _selectedFilters.remove(filter)
                                : _selectedFilters.add(filter);
                          });
                          _fetchFilteredStores();
                          _resetScroll();
                        },
                      ),
                    ],
                  ],
                ),
              ),

              // ── Scrollable Cards Section ─────────────────────────────────────
              Expanded(
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        16,
                        0,
                        16,
                        40,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: BlocBuilder<StoresCubit, StoresState>(
                          builder: (context, storesState) {
                            if (storesState is StoresLoading) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (storesState is StoresLoaded) {
                              final stores = storesState.items;
                              if (stores.isEmpty) {
                                return Column(
                                  children: [
                                    const SizedBox(height: 88),
                                    _EmptyListingState(l10n: l10n),
                                  ],
                                );
                              }

                              final majorStores = stores
                                  .where((s) => s.isMajor)
                                  .toList();
                              final normalStores = stores
                                  .where((s) => !s.isMajor)
                                  .toList();

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ── Major Stores (المتاجر الكبرى) ─────────────
                                  if (majorStores.isNotEmpty) ...[
                                    _SectionTitle(
                                      title: l10n.serviceLargeStores,
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      height: 106,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.zero,
                                        itemCount: majorStores.length,
                                        separatorBuilder: (_, _) =>
                                            const SizedBox(width: 12),
                                        itemBuilder: (context, index) {
                                          final s = majorStores[index];
                                          final mappedRestaurant = Restaurant(
                                            id: s.id.toString(),
                                            name: s.name,
                                            cuisineType: s.tags.isNotEmpty
                                                ? s.tags.first.name
                                                : '',
                                            coverImageUrl:
                                                s.cover ?? s.logo ?? '',
                                            logoUrl: s.logo ?? '',
                                            rating: s.ratingAvg ?? 0.0,
                                            ratingCount: s.ratingCount ?? 0,
                                            deliveryTimeMin:
                                                s.prepTimeFrom ?? 0,
                                            deliveryTimeMax: s.prepTimeTo ?? 0,
                                            deliveryFee: 0.0,
                                            isFavorited: false,
                                            isMajor: true,
                                            availability: s.availability,
                                            tags: s.tags
                                                .map((t) => t.name)
                                                .toList(),
                                          );
                                          return HypermarketMiniCard(
                                            market: mappedRestaurant,
                                            onTap: () {
                                              context.push(
                                                RouteNames.marketDetailsFor(
                                                  mappedRestaurant.id,
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],

                                  // ── All Normal Stores (كل الاماكن) ───────────
                                  if (normalStores.isNotEmpty) ...[
                                    _SectionTitle(title: l10n.serviceAllPlaces),
                                    const SizedBox(height: 12),
                                    _ServicePlaceCollection(
                                      items: normalStores
                                          .map(
                                            (s) => ServicePlaceData.store(
                                              id: s.id.toString(),
                                              name: s.name,
                                              time:
                                                  '${s.prepTimeFrom ?? 0}-${s.prepTimeTo ?? 0}',
                                              imageAsset:
                                                  s.cover ?? s.logo ?? '',
                                              rating:
                                                  s.ratingAvg?.toStringAsFixed(
                                                    1,
                                                  ) ??
                                                  '0.0',
                                              hasOffer: s.hasOffer,
                                              topRated: false,
                                              isMajor: false,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],

                                  // ── Nothing to show at all ───────────────────
                                  if (majorStores.isEmpty &&
                                      normalStores.isEmpty)
                                    Column(
                                      children: [
                                        const SizedBox(height: 88),
                                        _EmptyListingState(l10n: l10n),
                                      ],
                                    ),
                                ],
                              );
                            }

                            if (storesState is StoresError) {
                              return Center(child: Text(storesState.message));
                            }

                            return const SizedBox.shrink();
                          },
                        ),
                      ),
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

class _ListingHeader extends StatelessWidget {
  const _ListingHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => context.pop(),
            visualDensity: VisualDensity.compact,
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
            textAlign: TextAlign.start,
            style: AppTextStyles.heading4(
              context,
            ).copyWith(fontSize: 16, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _ListingSearchBox extends StatelessWidget {
  const _ListingSearchBox({
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppSearchField(
      controller: controller,
      hint: hint,
      onChanged: onChanged,
      iconAsset: AppAssets.serviceSearchIcon,
      textStyle: AppTextStyles.body(
        context,
      ).copyWith(fontSize: 12, height: 1.3),
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
        textAlign: TextAlign.start,
        style: AppTextStyles.heading4(
          context,
        ).copyWith(fontSize: 15, height: 1.4),
      ),
    );
  }
}

class _ServiceCategoryStrip extends StatelessWidget {
  const _ServiceCategoryStrip({
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  final List<entity_tag.Tag> categories;
  final entity_tag.Tag? selectedCategory;
  final ValueChanged<entity_tag.Tag> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 66,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 18),
        itemBuilder: (context, index) {
          return _ServiceCategoryChip(
            category: categories[index],
            selected: selectedCategory?.id == categories[index].id,
            onTap: () => onSelected(categories[index]),
          );
        },
      ),
    );
  }
}

class _ServiceCategoryChip extends StatelessWidget {
  const _ServiceCategoryChip({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final entity_tag.Tag category;
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
              child: category.image != null
                  ? AppNetworkImage(
                      category.image!,
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    )
                  : Icon(
                      Icons.storefront_outlined,
                      color: AppColors.paragraph(context),
                      size: 22,
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            category.name,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption(context).copyWith(
              color: selected ? AppColors.text : AppColors.paragraph(context),
              fontSize: 10,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceFilterStrip extends StatelessWidget {
  const _ServiceFilterStrip({
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
          for (var index = 0; index < filters.length; index++) ...[
            _ServiceFilterChip(
              filter: filters[index],
              selected: selectedFilters.contains(filters[index].id),
              onTap: () => onToggle(filters[index].id),
            ),
            if (index != filters.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _ServiceFilterChip extends StatelessWidget {
  const _ServiceFilterChip({
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

class _ServicePlaceCollection extends StatelessWidget {
  const _ServicePlaceCollection({required this.items});

  final List<ServicePlaceData> items;

  @override
  Widget build(BuildContext context) {
    return _PlaceList(items: items);
  }
}

class _PlaceList extends StatelessWidget {
  const _PlaceList({required this.items});

  final List<ServicePlaceData> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < items.length; index++) ...[
          SharedStoreListTile(item: items[index]),
          if (index != items.length - 1)
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

class _EmptyListingState extends StatelessWidget {
  const _EmptyListingState({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return const EmptyStateWidget(imageWidth: 100, imageHeight: 100);
  }
}

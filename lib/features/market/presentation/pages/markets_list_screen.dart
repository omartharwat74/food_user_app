import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/theme/app_colors.dart';
import '../cubit/market_favorite_cubit.dart';
import '../cubit/markets_list_cubit.dart';
import '../cubit/markets_list_state.dart';
import '../widgets/market_card.dart';
import '../widgets/market_empty_state.dart';

class MarketsListScreen extends StatefulWidget {
  const MarketsListScreen({super.key});

  @override
  State<MarketsListScreen> createState() => _MarketsListScreenState();
}

class _MarketsListScreenState extends State<MarketsListScreen> {
  late final MarketsListCubit _marketsListCubit;
  late final MarketFavoriteCubit _marketFavoriteCubit;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _marketsListCubit = GetIt.I<MarketsListCubit>()..fetchMarkets();
    _marketFavoriteCubit = GetIt.I<MarketFavoriteCubit>()
      ..fetchFavoriteMarkets();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _marketsListCubit.loadMore();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final theme = Theme.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _marketsListCubit),
        BlocProvider.value(value: _marketFavoriteCubit),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isArabic ? 'المتاجر والسوبرماركت' : 'Markets & Supermarkets',
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // ── Search & Filter Bar ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search Box
                  TextField(
                    controller: _searchController,
                    onChanged: (val) => _marketsListCubit.updateSearch(val),
                    decoration: InputDecoration(
                      hintText: isArabic
                          ? 'ابحث عن متجر أو سوبرماركت...'
                          : 'Search for a market...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _marketsListCubit.updateSearch(null);
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Filter Chips
                  BlocBuilder<MarketsListCubit, MarketsListState>(
                    builder: (context, state) {
                      final pickupActive =
                          state is MarketsListLoaded &&
                          state.pickupFilter == true;
                      final availableActive =
                          state is MarketsListLoaded &&
                          state.availableFilter == true;

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            FilterChip(
                              label: Text(
                                isArabic
                                    ? 'استلام من الفرع'
                                    : 'Pickup Available',
                              ),
                              selected: pickupActive,
                              onSelected: (_) =>
                                  _marketsListCubit.togglePickupFilter(),
                              selectedColor: AppColors.primary,
                              labelStyle: TextStyle(
                                color: pickupActive
                                    ? Colors.white
                                    : theme.textTheme.bodyMedium?.color,
                                fontWeight: pickupActive
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              checkmarkColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            const SizedBox(width: 8),
                            FilterChip(
                              label: Text(
                                isArabic ? 'متاح الآن' : 'Available Now',
                              ),
                              selected: availableActive,
                              onSelected: (_) =>
                                  _marketsListCubit.toggleAvailableFilter(),
                              selectedColor: AppColors.primary,
                              labelStyle: TextStyle(
                                color: availableActive
                                    ? Colors.white
                                    : theme.textTheme.bodyMedium?.color,
                                fontWeight: availableActive
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              checkmarkColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // ── Markets List Body ─────────────────────────────────────────────
            Expanded(
              child: BlocBuilder<MarketsListCubit, MarketsListState>(
                builder: (context, state) {
                  if (state is MarketsListLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (state is MarketsListError) {
                    return MarketEmptyState(
                      title: isArabic ? 'حدث خطأ' : 'Error Occurred',
                      message: state.message,
                      icon: Icons.error_outline,
                      onRetry: () => _marketsListCubit.fetchMarkets(),
                    );
                  }

                  if (state is MarketsListLoaded) {
                    if (state.markets.isEmpty) {
                      return MarketEmptyState(
                        title: isArabic
                            ? 'لا توجد متاجر متاحة'
                            : 'No Markets Available',
                        message: isArabic
                            ? 'لم نتمكن من العثور على متاجر مطابقة لبحثك.'
                            : 'No markets matched your search or filters.',
                        onRetry: () => _marketsListCubit.fetchMarkets(),
                      );
                    }

                    return RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () => _marketsListCubit.fetchMarkets(
                        search: state.searchQuery,
                        pickupAvailable: state.pickupFilter,
                        isAvailable: state.availableFilter,
                      ),
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount:
                            state.markets.length +
                            (state.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= state.markets.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          }
                          final market = state.markets[index];
                          return MarketCard(market: market);
                        },
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

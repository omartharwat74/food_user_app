import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/empty_state_widget.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_item.dart';
import 'package:food_user_app/features/restaurant/presentation/widgets/product_card.dart';
import 'package:food_user_app/features/store/data/models/hyper_sections_response.dart';
import 'package:food_user_app/features/store/presentation/cubit/store_search/store_search_cubit.dart';
import 'package:food_user_app/features/store/presentation/cubit/store_search/store_search_state.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

/// Search screen for a hypermarket/major store.
///
/// Figma: node #7162:4093 – #FAFAFA scaffold, back button, search field,
/// 2-column product grid (cards = node #8145:10237, mainAxisExtent 164).
class StoreSearchScreen extends StatefulWidget {
  final String storeId;

  const StoreSearchScreen({super.key, required this.storeId});

  @override
  State<StoreSearchScreen> createState() => _StoreSearchScreenState();
}

class _StoreSearchScreenState extends State<StoreSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Maps a [HyperProduct] from the search response → [MenuItem] for [ProductCard].
  MenuItem _toMenuItem(HyperProduct hp) => MenuItem(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Figma: #7162:4093 fills=[#FAFAFA]
      backgroundColor: AppColors.scaffoldBackground(context),
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header: back button + title ───────────────────────────────
              _buildHeader(context),

              // ── Search bar ────────────────────────────────────────────────
              _buildSearchBar(context),

              // ── Content: spinner / grid / empty / error ───────────────────
              Expanded(
                child: BlocBuilder<StoreSearchCubit, StoreSearchState>(
                  builder: (context, state) {
                    if (state is StoreSearchInitial) {
                      return _buildInitialState(context);
                    }
                    if (state is StoreSearchLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is StoreSearchError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.error),
                          ),
                        ),
                      );
                    }
                    if (state is StoreSearchLoaded) {
                      return _buildGrid(context, state);
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

  Widget _buildInitialState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search, size: 64, color: AppColors.hint(context)),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.startSearching,
            textAlign: TextAlign.center,
            style: AppTextStyles.body(
              context,
            ).copyWith(color: AppColors.hint(context), fontSize: 16),
          ),
        ],
      ),
    );
  }

  // ── Sub-builders ─────────────────────────────────────────────────────────

  /// Figma: #7162:4097 – back icon + "البحث" title, horizontal row, RTL.
  Widget _buildHeader(BuildContext context) {
    return Padding(
      // Figma: #7162:4403 left=16, gap=20 → 16px horizontal padding
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Back button — Figma: #7162:4098 instance of "back" component
          InkWell(
            onTap: () => context.pop(),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: AppColors.onSurface(context),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            AppLocalizations.of(context)!.search,
            style: AppTextStyles.heading4(context).copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface(context),
            ),
          ),
        ],
      ),
    );
  }

  /// Figma: #I7162:4321;6670:3614 – white card, border #E5E5E5 (0.5px),
  /// borderRadius 10px, padding 12px, search icon + hint text.
  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surfaceCard(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border(context), width: 0.5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Icon(Icons.search, color: AppColors.paragraph(context), size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchController,
                // No autofocus — keyboard must NOT open automatically
                autofocus: false,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                style: AppTextStyles.body(
                  context,
                ).copyWith(fontSize: 14, color: AppColors.onSurface(context)),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.searchPlaceholder,
                  hintStyle: AppTextStyles.body(
                    context,
                  ).copyWith(fontSize: 14, color: AppColors.paragraph(context)),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) => context.read<StoreSearchCubit>().search(
                  widget.storeId,
                  value,
                ),
                onSubmitted: (value) => context.read<StoreSearchCubit>().search(
                  widget.storeId,
                  value,
                ),
              ),
            ),
            // Clear button
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _searchController,
              builder: (_, value, _) {
                if (value.text.isEmpty) return const SizedBox.shrink();
                return GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    context.read<StoreSearchCubit>().search(widget.storeId, '');
                  },
                  child: Icon(
                    Icons.close,
                    size: 18,
                    color: AppColors.paragraph(context),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Figma: #7162:4331 grid – 2 columns, 12px gaps, mainAxisExtent=164.
  Widget _buildGrid(BuildContext context, StoreSearchLoaded state) {
    final items = state.products.map(_toMenuItem).toList();

    return CustomScrollView(
      slivers: [
        // Random suggestions banner (when is_random=true in meta)
        if (state.isRandom)
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'لا توجد نتائج دقيقة — عرض اقتراحات',
                      style: AppTextStyles.body(
                        context,
                      ).copyWith(color: AppColors.primary, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Empty state
        if (items.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyStateWidget(),
          )
        else
          // Product grid — exact same params as UnifiedResultsScreen
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                // Figma card height = 100px image + 64px content = 164px
                mainAxisExtent: 164,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    ProductCard(item: items[index], isGridMode: true),
                childCount: items.length,
              ),
            ),
          ),

        const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
      ],
    );
  }
}

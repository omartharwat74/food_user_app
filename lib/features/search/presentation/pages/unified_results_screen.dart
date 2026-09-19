import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:food_user_app/core/di/injection_container.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/features/search/presentation/cubit/unified_results_cubit.dart';
import 'package:food_user_app/features/search/presentation/cubit/unified_results_state.dart';
import 'package:food_user_app/features/search/presentation/models/results_config.dart';
import 'package:food_user_app/features/restaurant/presentation/widgets/product_card.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_category.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_item.dart';
import 'package:food_user_app/core/widgets/empty_state_widget.dart';

class UnifiedResultsScreen extends StatefulWidget {
  final ResultsConfig config;

  const UnifiedResultsScreen({
    super.key,
    required this.config,
  });

  @override
  State<UnifiedResultsScreen> createState() => _UnifiedResultsScreenState();
}

class _UnifiedResultsScreenState extends State<UnifiedResultsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UnifiedResultsCubit>()..loadResults(widget.config),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground(context),
        body: SafeArea(
          child: BlocBuilder<UnifiedResultsCubit, UnifiedResultsState>(
            builder: (context, state) {
              return state.when(
                initial: () => const Center(child: CircularProgressIndicator()),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (msg) => Center(child: Text(msg, style: const TextStyle(color: Colors.red))),
                loaded: (categories, searchResults, isSearchMode, selectedTabIndex, activeQuery) {

                  // The cubit already computed the correct items to show.
                  // • When a query is active   → searchResults (scoped to current tab)
                  // • When no query            → full tab pool (handled in cubit._tabItems)
                  //   but the cubit emits searchResults=[] when there is no query in
                  //   category mode, so we fall back to the tab expansion here.
                  final List<MenuItem> displayItems;
                  if (isSearchMode || activeQuery.isNotEmpty) {
                    displayItems = searchResults;
                  } else {
                    // Category mode, no active search — expand the selected tab
                    if (selectedTabIndex == 0) {
                      displayItems = categories.expand((c) => c.items).toList();
                    } else {
                      final catIndex = selectedTabIndex - 1;
                      displayItems = catIndex < categories.length
                          ? categories[catIndex].items
                          : [];
                    }
                  }

                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: CustomScrollView(
                      slivers: [
                        // 1. Top Header
                        SliverToBoxAdapter(
                          child: _buildHeader(context, isSearchMode: isSearchMode),
                        ),

                        // 2. Search Bar
                        SliverToBoxAdapter(
                          child: _buildSearchBar(context, isSearchMode: isSearchMode),
                        ),

                        // 3. Subcategory Tabs (Category Mode only)
                        if (!isSearchMode && categories.isNotEmpty)
                          SliverToBoxAdapter(
                            child: _buildSubcategoryTabs(
                              context,
                              categories,
                              selectedTabIndex: selectedTabIndex,
                            ),
                          ),

                        // 4. Section Title (Category Mode only, no active search)
                        if (!isSearchMode && activeQuery.isEmpty)
                          SliverToBoxAdapter(
                            child: _buildSectionTitle(
                              context,
                              categories,
                              selectedTabIndex: selectedTabIndex,
                            ),
                          ),

                        // 5. Search results label (Search Mode only)
                        if (isSearchMode && displayItems.isNotEmpty)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 16.0),
                              child: Text(
                                'نتائج البحث',
                                textAlign: TextAlign.right,
                                style: AppTextStyles.body(context).copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface(context),
                                ),
                              ),
                            ),
                          ),

                        // 6. Products Grid
                        if (displayItems.isEmpty)
                          const SliverFillRemaining(
                            hasScrollBody: false,
                            child: EmptyStateWidget(),
                          )
                        else
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            sliver: SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                mainAxisExtent: 164,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) =>
                                    ProductCard(item: displayItems[index], isGridMode: true),
                                childCount: displayItems.length,
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
        ),
      ),
    );
  }

  // ─── Widgets ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, {required bool isSearchMode}) {
    final title = isSearchMode
        ? 'بحث'
        : (widget.config.categoryName?.isNotEmpty == true
            ? widget.config.categoryName!
            : 'الأقسام');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => context.pop(),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(Icons.arrow_back_ios_new,
                  size: 20, color: AppColors.onSurface(context)),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            title,
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

  Widget _buildSearchBar(BuildContext context, {required bool isSearchMode}) {
    final placeholder =
        isSearchMode ? 'ابحث عن ما تحب' : 'ابحث باسم المنتج';

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 0.0),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surfaceCard(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border(context)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(Icons.search, color: AppColors.paragraph(context), size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchController,
                textDirection: TextDirection.rtl,
                textAlignVertical: TextAlignVertical.center,
                style: AppTextStyles.body(context).copyWith(
                  fontSize: 14,
                  color: AppColors.onSurface(context),
                ),
                decoration: InputDecoration(
                  hintText: placeholder,
                  hintTextDirection: TextDirection.rtl,
                  hintStyle: AppTextStyles.body(context).copyWith(
                    fontSize: 14,
                    color: AppColors.paragraph(context),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) =>
                    context.read<UnifiedResultsCubit>().search(value),
                onSubmitted: (value) =>
                    context.read<UnifiedResultsCubit>().search(value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubcategoryTabs(
    BuildContext context,
    List<MenuCategory> categories, {
    required int selectedTabIndex,
  }) {
    // Figma: inactive text = fill_90c767fe = #787878, active text = #141414 (active underline fill)
    const unselectedTextColor = Color(0xFF787878); // Figma: fill_90c767fe
    const selectedTextColor = Color(0xFF141414);   // Figma: active fill = "#141414"
    const activeUnderlineColor = Color(0xFF141414); // Figma: #8145:10028 fills=["#141414"]
    final strokeColor = AppColors.border(context);

    return Column(
      children: [
        const SizedBox(height: 4.0),
        Stack(
          children: [
          // Full-width bottom stroke — Figma: EL-2a86f094 height=1.5px

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(height: 1.5, color: strokeColor),
          ),
          // Scrollable tabs
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: categories.length + 1,
              itemBuilder: (context, index) {
                final isSelected = selectedTabIndex == index;
                final title = index == 0 ? 'الكل' : categories[index - 1].name;

                return GestureDetector(
                  onTap: () =>
                      context.read<UnifiedResultsCubit>().changeCategory(index),
                  child: Container(
                    height: 38,
                    margin: const EdgeInsetsDirectional.only(end: 24.0),
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            // Figma: active underline = #141414, height 1.5px
                            color: isSelected
                                ? activeUnderlineColor
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: Text(
                        title,
                        // Figma: active → Mobile/12 m (fontSize:12, weight:500, #141414)
                        // Figma: inactive → Mobile/Body Rmd (fontSize:12, weight:400, #787878)
                        style: TextStyle(
                          fontFamily: 'Expo Arabic',
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w500 : FontWeight.w400,
                          height: 1.3,
                          color:
                              isSelected ? selectedTextColor : unselectedTextColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      ],
    );
  }


  Widget _buildSectionTitle(
    BuildContext context,
    List<MenuCategory> categories, {
    required int selectedTabIndex,
  }) {
    String sectionTitle = 'الكل';
    if (selectedTabIndex > 0 && selectedTabIndex - 1 < categories.length) {
      sectionTitle = categories[selectedTabIndex - 1].name;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        sectionTitle,
        textAlign: TextAlign.right,
        // Figma: #8145:10157 textStyle=Mobile/Button → fontSize:14, weight:500, color:#1B1B1B
        style: const TextStyle(
          fontFamily: 'Expo Arabic',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.25,
          color: Color(0xFF1B1B1B),
        ),
      ),
    );
  }
}


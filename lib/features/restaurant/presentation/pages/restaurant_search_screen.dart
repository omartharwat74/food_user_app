import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/di/injection_container.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/restaurant_detail_cubit.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/restaurant_detail_state.dart';
import 'package:food_user_app/features/restaurant/presentation/widgets/product_card.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

class RestaurantSearchScreen extends StatefulWidget {
  const RestaurantSearchScreen({this.restaurantId = 'az-al-sham', super.key});

  final String restaurantId;

  @override
  State<RestaurantSearchScreen> createState() => _RestaurantSearchScreenState();
}

class _RestaurantSearchScreenState extends State<RestaurantSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      // Calling fetchStoreData which correctly hits /api/v1/stores/products/all
      create: (_) =>
          sl<RestaurantDetailCubit>()..fetchStoreData(widget.restaurantId),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground(context),
        appBar: AppBar(
          title: Text(l10n.searchTitle),
          centerTitle: false,
          titleSpacing: 0,
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: Column(
          children: [
            // Search Bar matches Figma precisely
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard(context),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.border(context),
                    width: 0.5,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: AppColors.paragraph(context),
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: l10n.searchPlaceholder,
                          hintStyle: AppTextStyles.body(
                            context,
                          ).copyWith(color: AppColors.hint(context)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (_query.isNotEmpty)
                      GestureDetector(
                        onTap: () => _searchController.clear(),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: AppColors.paragraph(context),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<RestaurantDetailCubit, RestaurantDetailState>(
                builder: (context, state) {
                  return state.when(
                    initial: () =>
                        const Center(child: CircularProgressIndicator()),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (msg) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          msg,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.error),
                        ),
                      ),
                    ),
                    loaded: (restaurant, menuCategories, branches, offers) {
                      // Flatten all categories to a single list of MenuItems
                      final allItems = menuCategories
                          .expand((c) => c.items)
                          .toList();

                      // Local filtering logic
                      final displayItems = _query.isEmpty
                          ? allItems
                          : allItems.where((item) {
                              return item.name.toLowerCase().contains(_query) ||
                                  item.description.toLowerCase().contains(
                                    _query,
                                  );
                            }).toList();

                      // Empty state
                      if (displayItems.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: AppColors.hint(context),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _query.isEmpty
                                    ? l10n.startSearching
                                    : l10n.searchEmptyTitle,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.paragraph(context),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Exact 2-column grid using ProductCard
                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              mainAxisExtent: 164,
                            ),
                        itemCount: displayItems.length,
                        itemBuilder: (context, index) {
                          return ProductCard(
                            item: displayItems[index],
                            isGridMode: true,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

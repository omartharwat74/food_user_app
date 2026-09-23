import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:food_user_app/features/search/presentation/cubit/search_state.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/app_spacing.dart';
import 'package:food_user_app/features/restaurant/presentation/widgets/restaurant_card.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.searchResultsTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppColors.scaffoldBackground(context),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (msg) => Center(child: Text(msg)),
            loaded: (result) {
              if (result.restaurants.isEmpty && result.items.isEmpty) {
                return Center(child: Text(l10n.serviceNoResultsAvailable));
              }
              return CustomScrollView(
                slivers: [
                  if (result.restaurants.isNotEmpty) ...[
                    SliverPadding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          result.isRandom
                              ? l10n.serviceNoResultsAvailable
                              : l10n.homeCategoryRestaurants,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SliverList.separated(
                      itemCount: result.restaurants.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final restaurant = result.restaurants[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                          child: RestaurantCard(
                            restaurant: restaurant,
                            width: double.infinity,
                          ),
                        );
                      },
                    ),
                  ],
                  if (result.items.isNotEmpty) ...[
                    SliverPadding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          l10n.itemsTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SliverList.separated(
                      itemCount: result.items.length,
                      separatorBuilder: (_, _) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = result.items[index];
                        return ListTile(
                          leading: item.imageUrl.isNotEmpty
                              ? Image.network(
                                  item.imageUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.fastfood),
                          title: Text(item.name),
                          subtitle: Text(item.description),
                          trailing: Text(
                            l10n.priceWithCurrency(item.price.toString()),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              );
            },
            orElse: () => Center(child: Text(l10n.startSearching)),
          );
        },
      ),
    );
  }
}

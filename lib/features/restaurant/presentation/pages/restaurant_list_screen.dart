import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/di/injection_container.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/app_spacing.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/restaurant_list_cubit.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/restaurant_list_state.dart';
import 'package:food_user_app/features/restaurant/presentation/widgets/restaurant_card.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

class RestaurantListScreen extends StatelessWidget {
  const RestaurantListScreen({super.key, this.categoryId});

  final String? categoryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RestaurantListCubit>(
      create: (context) =>
          sl<RestaurantListCubit>()..getRestaurants(categoryId: categoryId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.homeCategoryRestaurants),
        ),
        body: BlocBuilder<RestaurantListCubit, RestaurantListState>(
          builder: (context, state) {
            return state.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (message) => Center(
                child: Text(
                  message,
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
              loaded: (restaurants, hasMore, currentPage) {
                if (restaurants.isEmpty) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!.noRestaurantsFound,
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: restaurants.length + (hasMore ? 1 : 0),
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    if (index == restaurants.length) {
                      context.read<RestaurantListCubit>().loadMore(
                        categoryId: categoryId,
                      );
                      return const Center(child: CircularProgressIndicator());
                    }
                    return SizedBox(
                      height: 207, // Keep consistent with home screen height
                      child: RestaurantCard(restaurant: restaurants[index]),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

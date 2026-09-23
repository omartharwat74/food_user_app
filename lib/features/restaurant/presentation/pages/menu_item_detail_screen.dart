import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_item.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/menu_cubit.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/menu_state.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/app_spacing.dart';
import 'package:food_user_app/core/theme/text_styles.dart';

class MenuItemDetailScreen extends StatefulWidget {
  final MenuItem item;
  const MenuItemDetailScreen({required this.item, super.key});

  @override
  State<MenuItemDetailScreen> createState() => _MenuItemDetailScreenState();
}

class _MenuItemDetailScreenState extends State<MenuItemDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MenuCubit>().getItemModifiers(widget.item.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.item.name)),
      backgroundColor: AppColors.scaffoldBackground(context),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: widget.item.imageUrl.isNotEmpty
                ? Image.network(
                    widget.item.imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 250,
                    color: AppColors.primary,
                    child: const Center(
                      child: Icon(
                        Icons.fastfood,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.md),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.name,
                    style: AppTextStyles.heading1(
                      context,
                    ).copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    widget.item.description,
                    style: AppTextStyles.body(context),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'EGP ${widget.item.price.toStringAsFixed(2)}',
                    style: AppTextStyles.heading4(
                      context,
                    ).copyWith(color: AppColors.primary, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<MenuCubit, MenuState>(
            builder: (context, state) {
              return state.maybeWhen(
                loading: () => const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                ),
                modifiersLoaded: (modifiers) {
                  if (modifiers.isEmpty) {
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final modifier = modifiers[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              modifier.name,
                              style: AppTextStyles.heading4(context),
                            ),
                            ...modifier.options.map((opt) {
                              final optName = opt['name'] as String? ?? '';
                              final optPrice = opt['price'] as double? ?? 0.0;
                              return CheckboxListTile(
                                title: Text(optName),
                                subtitle: optPrice > 0
                                    ? Text(
                                        '+${AppLocalizations.of(context)!.currencyEgp} $optPrice',
                                      )
                                    : null,
                                value: false, // UI Mock
                                onChanged: (val) {},
                              );
                            }),
                          ],
                        ),
                      );
                    }, childCount: modifiers.length),
                  );
                },
                orElse: () =>
                    const SliverToBoxAdapter(child: SizedBox.shrink()),
              );
            },
          ),
        ],
      ),
    );
  }
}

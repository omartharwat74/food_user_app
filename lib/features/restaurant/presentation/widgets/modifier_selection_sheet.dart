import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/app_spacing.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_item.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/menu_cubit.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/menu_state.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

class ModifierSelectionSheet extends StatelessWidget {
  const ModifierSelectionSheet({super.key, required this.item});

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuCubit, MenuState>(
      builder: (context, state) {
        return state.maybeWhen(
          loading: () => const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          ),
          modifiersLoaded: (modifiers) {
            if (modifiers.isEmpty) {
              return const SizedBox.shrink();
            }
            return Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard(context),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Customize ${item.name}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...modifiers.map((modifier) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          modifier.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
                            value: false,
                            onChanged: (val) {},
                          );
                        }),
                      ],
                    );
                  }),
                  const SizedBox(height: AppSpacing.lg),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(AppLocalizations.of(context)!.applyButton),
                  ),
                ],
              ),
            );
          },
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}

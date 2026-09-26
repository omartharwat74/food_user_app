import 'package:flutter/material.dart';
import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

class AddressTypeSelector extends StatelessWidget {
  final String? initialValue;
  final ValueChanged<String> onChanged;

  const AddressTypeSelector({
    super.key,
    this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final types = [
      {'key': 'primary', 'label': l10n.addressTypeHome, 'icon': AppAssets.addressTypeHome},
      {'key': 'work', 'label': l10n.addressTypeWork, 'icon': AppAssets.addressTypeWork},
      {'key': 'other', 'label': l10n.addressTypeOffice, 'icon': AppAssets.addressTypeOffice},
    ];

    // Determine the active key. Default to 'primary' (Home) if null or unmapped.
    String activeKey = 'primary';
    if (initialValue != null) {
      final val = initialValue!.toLowerCase();
      if (val == 'work') {
        activeKey = 'work';
      } else if (val == 'other' || val == 'apartment' || val == 'office') {
        activeKey = 'other';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.deliveryToTitle,
          style: AppTextStyles.heading4(context).copyWith(
            fontSize: 16,
            color: AppColors.onSurface(context),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: types.map((type) {
            final isSelected = activeKey == type['key'];
            return Padding(
              padding: const EdgeInsetsDirectional.only(end: 10),
              child: InkWell(
                onTap: () {
                  if (!isSelected) {
                    onChanged(type['key'] as String);
                  }
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : AppColors.surfaceCard(context),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border(context),
                      width: isSelected ? 1.0 : 0.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        type['icon'] as String,
                        width: 18,
                        height: 18,
                        color: isSelected ? AppColors.primary : AppColors.paragraph(context),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        type['label'] as String,
                        style: AppTextStyles.body(context).copyWith(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? AppColors.primary : AppColors.paragraph(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

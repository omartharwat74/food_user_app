import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/widgets/app_media.dart';

class PhoneNumberField extends StatelessWidget {
  const PhoneNumberField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final phoneTextStyle = AppTextStyles.inputText(context).copyWith(
      color: Theme.of(context).textTheme.bodyLarge?.color ??
          AppColors.onSurface(context),
    );

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border(context), width: 0.5),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 16, end: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppSvgImage.asset(
                    AppAssets.flagEg,
                    width: 16,
                    height: 16,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '+20',
                    style: phoneTextStyle,
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 0.5,
                    height: 18,
                    color: AppColors.border(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                style: phoneTextStyle,
                cursorColor: AppColors.cursor(context),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: AppTextStyles.inputHint(context),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsetsDirectional.fromSTEB(
                    8,
                    14,
                    16,
                    14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

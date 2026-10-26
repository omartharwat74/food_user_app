import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/utils/extensions/context_ext.dart';

class ProductNotesDialog extends StatelessWidget {
  final String notes;

  const ProductNotesDialog({
    super.key,
    required this.notes,
  });

  static Future<void> show(BuildContext context, String notes) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => ProductNotesDialog(notes: notes),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.scaffoldBackground(context),
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: Center(
                      child: SvgPicture.asset(
                        AppAssets.orderDialogCloseIcon,
                        width: 17.57,
                        height: 17.57,
                        colorFilter: ColorFilter.mode(
                          AppColors.onSurface(context),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  context.l10n.productNotesDialogTitle,
                  style: TextStyle(
                    fontFamily: 'Expo Arabic',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 22.4 / 16.0,
                    color: AppColors.onSurface(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              notes,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: 'Expo Arabic',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 20.3 / 14.0,
                color: AppColors.onSurface(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

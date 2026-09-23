import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/theme/app_colors.dart';

class DeliveryTimeText extends StatelessWidget {
  final int minTime;
  final int maxTime;
  final TextStyle? style;

  const DeliveryTimeText({
    super.key,
    required this.minTime,
    required this.maxTime,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final textStyle =
        style ??
        AppTextStyles.caption(context).copyWith(
          fontSize: 10,
          height: 1.25,
          color: AppColors.onSurface(context),
        );

    if (isArabic) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.ltr,
            children: [
              Text(maxTime.toString(), style: textStyle),
              Text(' - ', style: textStyle),
              Text(minTime.toString(), style: textStyle),
            ],
          ),
          const SizedBox(width: 4),
          Text('دقيقة', style: textStyle),
        ],
      );
    } else {
      return Text('$minTime - $maxTime min', style: textStyle);
    }
  }
}

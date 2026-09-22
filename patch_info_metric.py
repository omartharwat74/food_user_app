import re

with open('lib/features/restaurant/presentation/pages/restaurant_detail_screen.dart', 'r') as f:
    content = f.read()

# Add import for DeliveryTimeText
if 'delivery_time_text.dart' not in content:
    content = content.replace("import 'package:food_user_app/l10n/app_localizations.dart';", "import 'package:food_user_app/l10n/app_localizations.dart';\nimport 'package:food_user_app/core/widgets/delivery_time_text.dart';")

old_info_metric = """class _InfoMetric extends StatelessWidget {
  const _InfoMetric({
    required this.assetName,
    required this.label,
    required this.iconOnRight,
  });

  final String assetName;
  final String label;
  final bool iconOnRight;

  @override
  Widget build(BuildContext context) {
    final icon = AppRasterImage.asset(assetName, width: 20, height: 20);
    final text = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.body(context).copyWith(fontSize: 12, height: 1.3),
    );"""

new_info_metric = """class _InfoMetric extends StatelessWidget {
  const _InfoMetric({
    required this.assetName,
    this.label,
    this.labelWidget,
    required this.iconOnRight,
  });

  final String assetName;
  final String? label;
  final Widget? labelWidget;
  final bool iconOnRight;

  @override
  Widget build(BuildContext context) {
    final icon = AppRasterImage.asset(assetName, width: 20, height: 20);
    final text = labelWidget ?? Text(
      label ?? '',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.body(context).copyWith(fontSize: 12, height: 1.3),
    );"""

content = content.replace(old_info_metric, new_info_metric)

# Replace the delivery time usage
old_clock_usage = """                      Expanded(
                        child: _InfoMetric(
                          assetName: AppAssets.restaurantWallClockIcon,
                          label: isArabic
                              ? '${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} دقيقة'
                              : '${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} min',
                          iconOnRight: true,
                        ),
                      ),"""

new_clock_usage = """                      Expanded(
                        child: _InfoMetric(
                          assetName: AppAssets.restaurantWallClockIcon,
                          labelWidget: DeliveryTimeText(
                            minTime: restaurant.deliveryTimeMin,
                            maxTime: restaurant.deliveryTimeMax,
                            style: AppTextStyles.body(context).copyWith(fontSize: 12, height: 1.3),
                          ),
                          iconOnRight: true,
                        ),
                      ),"""
content = content.replace(old_clock_usage, new_clock_usage)

old_clock_usage_ltr = """                      Expanded(
                        child: _InfoMetric(
                          assetName: AppAssets.restaurantWallClockIcon,
                          label:
                              '${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} min',
                          iconOnRight: false,
                        ),
                      ),"""
new_clock_usage_ltr = """                      Expanded(
                        child: _InfoMetric(
                          assetName: AppAssets.restaurantWallClockIcon,
                          labelWidget: DeliveryTimeText(
                            minTime: restaurant.deliveryTimeMin,
                            maxTime: restaurant.deliveryTimeMax,
                            style: AppTextStyles.body(context).copyWith(fontSize: 12, height: 1.3),
                          ),
                          iconOnRight: false,
                        ),
                      ),"""
content = content.replace(old_clock_usage_ltr, new_clock_usage_ltr)

with open('lib/features/restaurant/presentation/pages/restaurant_detail_screen.dart', 'w') as f:
    f.write(content)

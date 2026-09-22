import re

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'r') as f:
    content = f.read()

if 'delivery_time_text.dart' not in content:
    content = content.replace("import 'package:food_user_app/l10n/app_localizations.dart';", "import 'package:food_user_app/l10n/app_localizations.dart';\nimport 'package:food_user_app/core/widgets/delivery_time_text.dart';")

# 1. Update _FactRow to accept widget
old_fact_row = """class _FactRow extends StatelessWidget {
  const _FactRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body(
              context,
            ).copyWith(fontSize: 14, fontWeight: FontWeight.w400, height: 1.4),
          ),
          Text(
            value,
            style: AppTextStyles.body(context).copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.4,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}"""
new_fact_row = """class _FactRow extends StatelessWidget {
  const _FactRow({required this.label, this.value, this.valueWidget});

  final String label;
  final String? value;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body(
              context,
            ).copyWith(fontSize: 14, fontWeight: FontWeight.w400, height: 1.4),
          ),
          valueWidget ?? Text(
            value ?? '',
            style: AppTextStyles.body(context).copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.4,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}"""
content = content.replace(old_fact_row, new_fact_row)

# 2. Update _RestaurantFacts to not use a strict tuple or to map to _FactRow directly
old_facts_build = """    final facts = [
      (
        copy.deliveryPrice,
        isArabic
            ? '${restaurant.deliveryFee.toFormattedPrice()} ج.م'
            : 'EGP ${restaurant.deliveryFee.toFormattedPrice()}',
      ),
      (
        copy.minimumOrder,
        isArabic ? '0 ج.م' : 'EGP 0',
      ),
      (
        copy.deliveryTime,
        isArabic
            ? '${restaurant.deliveryTimeMin} - ${restaurant.deliveryTimeMax} دقيقة'
            : '${restaurant.deliveryTimeMin} - ${restaurant.deliveryTimeMax} min',
      ),
      (copy.address, restaurant.address),
      (copy.previousOrders, '-'),
    ];

    return Column(
      children: [
        for (final fact in facts) _FactRow(label: fact.$1, value: fact.$2),
        _PaymentRow(label: copy.paymentMethod),
      ],
    );"""
new_facts_build = """    return Column(
      children: [
        _FactRow(
          label: copy.deliveryPrice,
          value: isArabic
              ? '${restaurant.deliveryFee.toFormattedPrice()} ج.م'
              : 'EGP ${restaurant.deliveryFee.toFormattedPrice()}',
        ),
        _FactRow(
          label: copy.minimumOrder,
          value: isArabic ? '0 ج.م' : 'EGP 0',
        ),
        _FactRow(
          label: copy.deliveryTime,
          valueWidget: DeliveryTimeText(
            minTime: restaurant.deliveryTimeMin,
            maxTime: restaurant.deliveryTimeMax,
            style: AppTextStyles.body(context).copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.4,
              color: AppColors.primary,
            ),
          ),
        ),
        _FactRow(label: copy.address, value: restaurant.address),
        _FactRow(label: copy.previousOrders, value: '-'),
        _PaymentRow(label: copy.paymentMethod),
      ],
    );"""
content = content.replace(old_facts_build, new_facts_build)

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'w') as f:
    f.write(content)

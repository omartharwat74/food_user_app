import re

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'r') as f:
    content = f.read()

# 1. Add import if missing
if 'delivery_time_text.dart' not in content:
    content = content.replace("import 'package:food_user_app/l10n/app_localizations.dart';", "import 'package:food_user_app/l10n/app_localizations.dart';\nimport 'package:food_user_app/core/widgets/delivery_time_text.dart';")

# 2. Fix the spacing from 14 to 12
old_spacing = """                  _SectionHeader(title: copy.moreDetails),
                  const SizedBox(height: 14),
                  _RestaurantFacts("""
new_spacing = """                  _SectionHeader(title: copy.moreDetails),
                  const SizedBox(height: 12),
                  _RestaurantFacts("""
content = content.replace(old_spacing, new_spacing)

# 3. Replace _FactRow
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

# 4. Replace _RestaurantFacts using regex because formatting can be tricky
regex = re.compile(r"final facts = \[\s*\([\s\S]*?\];\s*return Column\(\s*children: \[\s*for \(final fact in facts\) _FactRow\(label: fact\.\$1, value: fact\.\$2\),\s*_PaymentRow\(label: copy\.paymentMethod\),\s*\],\s*\);")

new_facts_build = """return Column(
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

content = regex.sub(new_facts_build, content)

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'w') as f:
    f.write(content)

print("Done")

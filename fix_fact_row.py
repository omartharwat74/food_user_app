with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'r') as f:
    content = f.read()

old_fact = """class _FactRow extends StatelessWidget {
  const _FactRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final valueText = Flexible(
      child: Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: isArabic ? TextAlign.start : TextAlign.end,
        style: AppTextStyles.caption(context).copyWith(
          color: AppColors.onSurface(context),
          fontSize: 12,
          height: 1.3,
        ),
      ),
    );
    final labelText = Text(
      label,
      style: AppTextStyles.body(context).copyWith(
        color: AppColors.paragraph(context),
        fontSize: 12,
        height: 1.3,
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: isArabic
            ? [labelText, const SizedBox(width: 8), valueText]
            : [labelText, const SizedBox(width: 8), valueText],
      ),
    );
  }
}"""

new_fact = """class _FactRow extends StatelessWidget {
  const _FactRow({required this.label, this.value, this.valueWidget});

  final String label;
  final String? value;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final valueText = Flexible(
      child: valueWidget ?? Text(
        value ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: isArabic ? TextAlign.start : TextAlign.end,
        style: AppTextStyles.caption(context).copyWith(
          color: AppColors.onSurface(context),
          fontSize: 12,
          height: 1.3,
        ),
      ),
    );
    final labelText = Text(
      label,
      style: AppTextStyles.body(context).copyWith(
        color: AppColors.paragraph(context),
        fontSize: 12,
        height: 1.3,
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: isArabic
            ? [labelText, const SizedBox(width: 8), valueText]
            : [labelText, const SizedBox(width: 8), valueText],
      ),
    );
  }
}"""
content = content.replace(old_fact, new_fact)

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'w') as f:
    f.write(content)

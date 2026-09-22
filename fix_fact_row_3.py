with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'r') as f:
    content = f.read()

import re

# We will restore the original _FactRow but with valueWidget support.
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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border(context), width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.ltr,
        children: isArabic
            ? [valueText, const SizedBox(width: 12), labelText]
            : [labelText, const SizedBox(width: 12), valueText],
      ),
    );
  }
}"""

content = re.sub(r'class _FactRow extends StatelessWidget \{[\s\S]*?\}\n\}', new_fact, content)

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'w') as f:
    f.write(content)

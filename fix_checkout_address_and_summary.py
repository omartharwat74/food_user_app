import re

with open('lib/features/checkout/presentation/pages/checkout_screen.dart', 'r') as f:
    content = f.read()

# 1. Update Typography of Summary Rows
new_build_summary_row = """Widget _buildSummaryRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1B1B1B),
              fontSize: 12,
              fontFamily: 'Expo Arabic',
              fontWeight: FontWeight.w400,
              height: 1.30,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1B1B1B),
              fontSize: 12,
              fontFamily: 'Expo Arabic',
              fontWeight: FontWeight.w400,
              height: 1.30,
            ),
          ),
        ],
      ),
    );
  }"""
content = re.sub(r'Widget _buildSummaryRow\(.*?\) \{.*?(?=  @override\n  Widget build)', new_build_summary_row + '\n\n', content, flags=re.DOTALL)

# 2. Update Typography of Summary Header
content = re.sub(
    r"Text\(\s*'ملخص الطلب :',\s*style: AppTextStyles\.body\(context\)\.copyWith\(\s*color: AppColors\.onSurface\(context\),\s*fontSize: 14,\s*fontWeight: FontWeight\.w600,\s*\),\s*\),",
    """Text(
                            'ملخص الطلب :',
                            style: const TextStyle(
                              color: Color(0xFF1B1B1B),
                              fontSize: 14,
                              fontFamily: 'Expo Arabic',
                              fontWeight: FontWeight.bold,
                            ),
                          ),""",
    content
)

# 3. Add strict Divider
content = content.replace(
    'const Divider(height: 16, thickness: 1),',
    'const Divider(color: Color(0xFFE5E5E5), thickness: 0.5, height: 0.5),'
)

# 4. Total Row Layout & Color
total_row_pattern = r"Row\(\s*children: \[\s*Icon\(\s*isSummaryExpanded \? Icons\.keyboard_arrow_down : Icons\.keyboard_arrow_up,.*?RichText\(.*?\),\s*\],\s*\)"
new_total_row = """Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الاجمالي : ${total.toFormattedPrice()} ج.م',
                        style: const TextStyle(
                          color: Color(0xFF1B1B1B),
                          fontSize: 14,
                          fontFamily: 'Expo Arabic',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        isSummaryExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                        color: const Color(0xFF1B1B1B),
                      ),
                    ],
                  )"""
content = re.sub(total_row_pattern, new_total_row, content, flags=re.DOTALL)


# 5. Fix Address Binding
content = content.replace(
    'final selectedSavedAddress = addressesController.selectedAddress?.location(\n      Localizations.localeOf(context),\n    );',
    'final selectedSavedAddress = addressesController.selectedAddress?.fullAddress ?? addressesController.selectedAddress?.titleAr;'
)

with open('lib/features/checkout/presentation/pages/checkout_screen.dart', 'w') as f:
    f.write(content)


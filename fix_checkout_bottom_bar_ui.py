import re

with open('lib/features/checkout/presentation/pages/checkout_screen.dart', 'r') as f:
    content = f.read()

# 1. Update _buildSummaryRow fonts
new_build_summary_row = """Widget _buildSummaryRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1B1B1B),
              fontSize: 14,
              fontFamily: 'Expo Arabic',
              fontWeight: FontWeight.w500,
              height: 1.30,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1B1B1B),
              fontSize: 14,
              fontFamily: 'Expo Arabic',
              fontWeight: FontWeight.w500,
              height: 1.30,
            ),
          ),
        ],
      ),
    );
  }"""
content = re.sub(r'Widget _buildSummaryRow\(.*?\) \{.*?(?=  @override\n  Widget build)', new_build_summary_row + '\n\n', content, flags=re.DOTALL)

# 2. Update Padding and spacing in the main container
content = content.replace(
    'padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, bottomSafe + 20),',
    'padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, bottomSafe > 0 ? bottomSafe : 24),'
)

# Update the toggle text styles and spacing
# First, the 'ملخص الطلب :' header
content = content.replace(
    """const Text(
                            'ملخص الطلب :',
                            style: TextStyle(
                              color: Color(0xFF1B1B1B),
                              fontSize: 14,
                              fontFamily: 'Expo Arabic',
                              fontWeight: FontWeight.bold,
                            ),
                          ),""",
    """const Text(
                            'ملخص الطلب :',
                            style: TextStyle(
                              color: Color(0xFF1B1B1B),
                              fontSize: 16,
                              fontFamily: 'Expo Arabic',
                              fontWeight: FontWeight.bold,
                            ),
                          ),"""
)

# Remove the SizedBox(height: 4) above the toggle row
content = content.replace('const SizedBox(height: 4),\n              InkWell(', 'InkWell(')

# Update Toggle Row padding to 0 or symmetric(vertical: 0)
content = content.replace('padding: const EdgeInsets.symmetric(vertical: 8.0),', 'padding: const EdgeInsets.symmetric(vertical: 4.0),')

# Update Total Row font size to 16
content = content.replace(
    """Text(
                        'الاجمالي : ${total.toFormattedPrice()} ج.م',
                        style: const TextStyle(
                          color: Color(0xFF1B1B1B),
                          fontSize: 14,
                          fontFamily: 'Expo Arabic',
                          fontWeight: FontWeight.bold,
                        ),
                      ),""",
    """Text(
                        'الاجمالي : ${total.toFormattedPrice()} ج.م',
                        style: const TextStyle(
                          color: Color(0xFF1B1B1B),
                          fontSize: 16,
                          fontFamily: 'Expo Arabic',
                          fontWeight: FontWeight.bold,
                        ),
                      ),"""
)

# Change Icon to 24px and Color
content = content.replace(
    """Icon(
                        isSummaryExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                        color: const Color(0xFF1B1B1B),
                      ),""",
    """Icon(
                        isSummaryExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                        color: const Color(0xFF1B1B1B),
                        size: 24,
                      ),"""
)

with open('lib/features/checkout/presentation/pages/checkout_screen.dart', 'w') as f:
    f.write(content)


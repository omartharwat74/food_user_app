import re

with open('lib/features/cart/presentation/widgets/cart_summary.dart', 'r') as f:
    content = f.read()

# Add tax to CartSummary constructor and fields
content = re.sub(r'    required this\.delivery,\n    required this\.discount,\n    required this\.total,', r'    required this.delivery,\n    required this.tax,\n    required this.discount,\n    required this.total,', content)

content = re.sub(r'  final int delivery;\n  final int discount;', r'  final int delivery;\n  final int tax;\n  final int discount;', content)

# Add tax row to the UI
# Find where the delivery row is
tax_row = """          const SizedBox(height: 12),
          _SummaryRow(
            label: l10n.orderDeliveryFee,
            value: l10n.cartPrice(delivery),
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            label: 'الضريبة',
            value: l10n.cartPrice(tax),
          ),"""

content = re.sub(r'          const SizedBox\(height: 12\),\n          _SummaryRow\(\n            label: l10n\.orderDeliveryFee,\n            value: l10n\.cartPrice\(delivery\),\n          \),', tax_row, content)

with open('lib/features/cart/presentation/widgets/cart_summary.dart', 'w') as f:
    f.write(content)


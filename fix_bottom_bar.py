import re

with open('lib/features/product/presentation/pages/product_details_screen.dart', 'r') as f:
    content = f.read()

content = content.replace('  final int total;\n  final VoidCallback onIncrement;', '  final double total;\n  final VoidCallback onIncrement;')

with open('lib/features/product/presentation/pages/product_details_screen.dart', 'w') as f:
    f.write(content)


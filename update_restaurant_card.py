import re

with open('lib/features/restaurant/presentation/widgets/restaurant_card.dart', 'r') as f:
    content = f.read()

# Change height 124 to 104
content = re.sub(r'SizedBox\(\n\s*height: 124,', r'SizedBox(\n                height: 104,', content)

# Change Padding fromSTEB(8, 8, 8, 10) to fromSTEB(8, 8, 8, 4)
content = content.replace('EdgeInsetsDirectional.fromSTEB(8, 8, 8, 10)', 'EdgeInsetsDirectional.fromSTEB(8, 8, 8, 4)')

# Reduce spacing: SizedBox(height: 8) -> SizedBox(height: 2) between texts
# But there's also SizedBox(height: 4) before tags.
content = content.replace('const SizedBox(height: 8),\n                    Text(\n                      restaurant.cuisineType,', 'const SizedBox(height: 2),\n                    Text(\n                      restaurant.cuisineType,')
content = content.replace('const SizedBox(height: 8),\n                    Row(\n                      children: [\n                        const Icon(', 'const SizedBox(height: 2),\n                    Row(\n                      children: [\n                        const Icon(')

with open('lib/features/restaurant/presentation/widgets/restaurant_card.dart', 'w') as f:
    f.write(content)


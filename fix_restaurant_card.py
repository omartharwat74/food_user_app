import re

with open('lib/features/restaurant/presentation/widgets/restaurant_card.dart', 'r') as f:
    content = f.read()

# 1. Padding
content = content.replace(
    'padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 4),',
    'padding: const EdgeInsets.all(8),'
)

# 2. Spacing before tags
content = content.replace(
    'const SizedBox(height: 4),\n                      Row(',
    'const SizedBox(height: 8),\n                      Row('
)

# 3. Spacing before schedule row
content = content.replace(
    'const SizedBox(height: 2),\n                    Row(\n                      children: [\n                        const Icon(\n                          Icons.schedule_rounded,',
    'const SizedBox(height: 8),\n                    Row(\n                      children: [\n                        const Icon(\n                          Icons.schedule_rounded,'
)

with open('lib/features/restaurant/presentation/widgets/restaurant_card.dart', 'w') as f:
    f.write(content)


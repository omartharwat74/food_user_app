import re

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'r') as f:
    content = f.read()

content = content.replace("const _Stars(size: 24),", "_Stars(size: 24, selectedCount: rating.round()),")

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'w') as f:
    f.write(content)

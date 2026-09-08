import re

with open('lib/features/restaurant/presentation/widgets/restaurant_card.dart', 'r') as f:
    content = f.read()

old_badge = """        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,"""

new_badge = """        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          text,"""

content = content.replace(old_badge, new_badge)

with open('lib/features/restaurant/presentation/widgets/restaurant_card.dart', 'w') as f:
    f.write(content)


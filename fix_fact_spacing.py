with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'r') as f:
    content = f.read()

old_spacing = """                  _SectionHeader(title: copy.moreDetails),
                  const SizedBox(height: 12),
                  _RestaurantFacts("""

new_spacing = """                  _SectionHeader(title: copy.moreDetails),
                  _RestaurantFacts("""
content = content.replace(old_spacing, new_spacing)

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'w') as f:
    f.write(content)

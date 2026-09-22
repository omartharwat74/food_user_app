with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'r') as f:
    content = f.read()

old_block = """                    const SizedBox(height: 18),
                  ],
                  _SectionHeader(title: copy.moreDetails),"""

new_block = """                    const SizedBox(height: 18),
                  ] else ...[
                    const SizedBox(height: 16),
                  ],
                  _SectionHeader(title: copy.moreDetails),"""

content = content.replace(old_block, new_block)

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'w') as f:
    f.write(content)

import re

with open('lib/features/restaurant/presentation/widgets/restaurant_card.dart', 'r') as f:
    content = f.read()

# I will replace from `if (restaurant.tags.isNotEmpty) ...[` down to the end of `cuisineType` block with exactly what the user provided.
# Actually let's use regex

pattern = r"if \(restaurant\.tags\.isNotEmpty\) \.\.\.\[.*?const SizedBox\(height: 2\),\s*Text\(\s*restaurant\.cuisineType,.*?\)\.copyWith\(fontSize: 10, height: 1\.25\),\s*\),"
replacement = """if (restaurant.tags.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              restaurant.tags.map((t) => t.name).join(' ، '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style: AppTextStyles.caption(context).copyWith(
                                fontSize: 10,
                                height: 1.25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],"""

content = re.sub(pattern, replacement, content, flags=re.DOTALL)

with open('lib/features/restaurant/presentation/widgets/restaurant_card.dart', 'w') as f:
    f.write(content)


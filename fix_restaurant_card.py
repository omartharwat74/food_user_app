import re

with open('lib/features/restaurant/presentation/widgets/restaurant_card.dart', 'r') as f:
    content = f.read()

# Change height 104 back to 124
content = content.replace('height: 104,', 'height: 124,')

# Wrap tags Text in a Row -> Expanded
tags_code = """                    if (restaurant.tags.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              restaurant.tags.join(' ، '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style: AppTextStyles.caption(context).copyWith(fontSize: 10, height: 1.25),
                            ),
                          ),
                        ],
                      ),
                    ] else"""

old_tags_code = r"                    if \(restaurant.tags.isNotEmpty\) \.\.\.\[\n                      const SizedBox\(height: 4\),\n                      Text\(\n                        restaurant.tags.join\(' ، '\),\n                        maxLines: 1,\n                        overflow: TextOverflow.ellipsis,\n                        textAlign: TextAlign.start,\n                        style: AppTextStyles.caption\(context\).copyWith\(fontSize: 10, height: 1.25\),\n                      \),\n                    \] else"

content = re.sub(old_tags_code, tags_code, content)

with open('lib/features/restaurant/presentation/widgets/restaurant_card.dart', 'w') as f:
    f.write(content)


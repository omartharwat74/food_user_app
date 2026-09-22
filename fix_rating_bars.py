import re

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'r') as f:
    content = f.read()

# Update _RatingSummary constructor
content = content.replace("const _RatingSummary({\n    required this.rating,\n    required this.ratingCount,\n    required this.copy,\n  });\n\n  final double rating;\n  final String ratingCount;\n  final _RateCopy copy;", "const _RatingSummary({\n    required this.rating,\n    required this.ratingCount,\n    required this.copy,\n    required this.ratingDistribution,\n  });\n\n  final double rating;\n  final String ratingCount;\n  final _RateCopy copy;\n  final Map<String, dynamic> ratingDistribution;")

# Update _RatingSummary usage
content = content.replace("ratingCount: restaurant.ratingCount.toString(),\n                    copy: copy,\n                  ),", "ratingCount: restaurant.ratingCount.toString(),\n                    copy: copy,\n                    ratingDistribution: restaurant.ratingDistribution,\n                  ),")

# Update _RatingBars usage in _RatingSummary
content = content.replace("          Container(width: 1, height: 40, color: AppColors.border(context)),\n          const _RatingBars(),\n        ],\n      ),\n    );\n  }\n}", "          Container(width: 1, height: 40, color: AppColors.border(context)),\n          _RatingBars(ratingDistribution: ratingDistribution, ratingCount: int.tryParse(ratingCount) ?? 0),\n        ],\n      ),\n    );\n  }\n}")

# Update _RatingBars definition
rating_bars_new = """class _RatingBars extends StatelessWidget {
  const _RatingBars({required this.ratingDistribution, required this.ratingCount});
  
  final Map<String, dynamic> ratingDistribution;
  final int ratingCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(5, (index) {
        final score = 5 - index;
        final count = (ratingDistribution[score.toString()] as num?)?.toInt() ?? 0;
        final value = ratingCount > 0 ? (count / ratingCount) : 0.0;
        
        return Padding(
"""
content = re.sub(r"class _RatingBars extends StatelessWidget \{\n  const _RatingBars\(\);\n\n  static const _values = \[0\.94, 0\.64, 0\.54, 0\.82, 0\.19\];\n\n  @override\n  Widget build\(BuildContext context\) \{\n    return Column\(\n      children: List\.generate\(5, \(index\) \{\n        final value = _values\[index\];\n        final score = 5 - index;\n        return Padding\(", rating_bars_new, content)

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'w') as f:
    f.write(content)

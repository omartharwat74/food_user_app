import re

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'r') as f:
    content = f.read()

# Modify invocation in _RatingSummary
content = content.replace("final bars = _RatingBars(isArabic: isArabic);", "final bars = _RatingBars(isArabic: isArabic, ratingCount: ratingCount, ratingDistribution: ratingDistribution);")

# Modify _RatingBars class
old_rating_bars = """class _RatingBars extends StatelessWidget {
  const _RatingBars({required this.isArabic});

  final bool isArabic;

  static const _values = [0.94, 0.64, 0.54, 0.82, 0.19];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(5, (index) {
        final value = _values[index];
        final score = 5 - index;"""

new_rating_bars = """class _RatingBars extends StatelessWidget {
  const _RatingBars({
    required this.isArabic,
    required this.ratingCount,
    required this.ratingDistribution,
  });

  final bool isArabic;
  final int ratingCount;
  final Map<String, dynamic> ratingDistribution;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(5, (index) {
        final score = 5 - index;
        final count = (ratingDistribution[score.toString()] as num?)?.toInt() ?? 0;
        final value = ratingCount > 0 ? (count / ratingCount) : 0.0;"""

content = content.replace(old_rating_bars, new_rating_bars)

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'w') as f:
    f.write(content)

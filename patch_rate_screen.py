import re

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'r') as f:
    content = f.read()

# Remove the outer RestaurantRateScreen class
content = re.sub(r'class RestaurantRateScreen extends StatelessWidget \{.*?\}\s*\}', '', content, flags=re.DOTALL)

# Rename _RestaurantRateView to RestaurantRateScreen and update constructor
content = content.replace('class _RestaurantRateView extends StatelessWidget {', 'class RestaurantRateScreen extends StatelessWidget {')
content = content.replace('const _RestaurantRateView({required this.restaurantId});\n  final String restaurantId;', 'const RestaurantRateScreen({required this.restaurant, super.key});\n  final Restaurant restaurant;')

# Replace Scaffold & BlocBuilder with Container
new_build = """  @override
  Widget build(BuildContext context) {
    final copy = _RateCopy.of(context);
    final locale = Localizations.localeOf(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
"""

old_build_regex = r"  @override\n  Widget build\(BuildContext context\) \{\n    final copy = _RateCopy\.of\(context\);\n    final locale = Localizations\.localeOf\(context\);\n\n    return Scaffold\([\s\S]*?child: CustomScrollView\("

content = re.sub(old_build_regex, new_build, content)

# Remove the closing brackets for BlocBuilder and state.maybeWhen
closing_regex = r"              \);\n            \},\n            orElse: \(\) => const SizedBox\.shrink\(\),\n          \);\n        \},\n      \),\n    \);"
content = re.sub(closing_regex, "              );\n  }", content)

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'w') as f:
    f.write(content)

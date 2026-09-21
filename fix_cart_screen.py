import re

with open('lib/features/cart/presentation/pages/cart_screen.dart', 'r') as f:
    content = f.read()

# I see it replaced all of them. So I'll just remove the duplicated ones.
# The widgets are: _CartEmptyPlaceholder, _CartHeader
# In _CartEmptyPlaceholder:
content = re.sub(r'class _CartEmptyPlaceholder extends StatelessWidget \{[\s\S]*?  final AppLocalizations l10n;\n\n  @override\n  void initState\(\) \{[\s\S]*?  Widget build\(BuildContext context\) \{', r'class _CartEmptyPlaceholder extends StatelessWidget {\n  const _CartEmptyPlaceholder({required this.l10n});\n\n  final AppLocalizations l10n;\n\n  @override\n  Widget build(BuildContext context) {', content)

# In _CartHeader:
content = re.sub(r'class _CartHeader extends StatelessWidget \{[\s\S]*?  final String\? restaurantName;\n\n  @override\n  void initState\(\) \{[\s\S]*?  Widget build\(BuildContext context\) \{', r'class _CartHeader extends StatelessWidget {\n  const _CartHeader({required this.l10n, this.restaurantName});\n\n  final AppLocalizations l10n;\n  final String? restaurantName;\n\n  @override\n  Widget build(BuildContext context) {', content)

with open('lib/features/cart/presentation/pages/cart_screen.dart', 'w') as f:
    f.write(content)


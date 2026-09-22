with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'r') as f:
    content = f.read()

# Add `final isArabic = locale.languageCode == 'ar';` to _RestaurantFacts build method
new_facts_build = """  @override
  Widget build(BuildContext context) {
    final isArabic = locale.languageCode == 'ar';
    final facts = ["""
content = content.replace("""  @override
  Widget build(BuildContext context) {
    final facts = [""", new_facts_build)

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'w') as f:
    f.write(content)

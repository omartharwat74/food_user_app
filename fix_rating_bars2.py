with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'r') as f:
    content = f.read()

content = content.replace("ratingCount: int.tryParse(ratingCount) ?? 0", "ratingCount: ratingCount")
content = content.replace("ratingCount.toString()", "ratingCount")

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'w') as f:
    f.write(content)

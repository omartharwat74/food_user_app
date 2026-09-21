import re

for filepath in ['lib/features/home/presentation/pages/home_screen.dart', 'lib/features/restaurant/presentation/pages/restaurant_list_screen.dart']:
    try:
        with open(filepath, 'r') as f:
            content = f.read()

        # Find SizedBox(height: <something>, child: ListView.builder(... RestaurantCard ...))
        # It's usually `SizedBox(height: 228,` or `209`.
        # I'll just regex replace `SizedBox(height: 228` to `SizedBox(height: 207` if it's near RestaurantCard.
        # But let's check what it currently is.
    except Exception as e:
        print(f"Error on {filepath}: {e}")

import re

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'r') as f:
    content = f.read()

# Add import
if 'price_extension.dart' not in content:
    content = content.replace("import 'package:flutter_bloc/flutter_bloc.dart';", "import 'package:flutter_bloc/flutter_bloc.dart';\nimport 'package:food_user_app/core/utils/price_extension.dart';")

content = content.replace("restaurant.deliveryFee.toInt()", "restaurant.deliveryFee.toFormattedPrice()")

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'w') as f:
    f.write(content)

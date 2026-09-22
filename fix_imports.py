def add_import(filename, import_stmt):
    with open(filename, 'r') as f:
        content = f.read()
    if import_stmt not in content:
        content = content.replace("import 'package:flutter/material.dart';", f"import 'package:flutter/material.dart';\n{import_stmt}")
        with open(filename, 'w') as f:
            f.write(content)

add_import('lib/features/restaurant/presentation/widgets/restaurant_card.dart', "import 'package:food_user_app/core/widgets/delivery_time_text.dart';")
add_import('lib/features/market/presentation/widgets/market_card.dart', "import 'package:food_user_app/core/widgets/delivery_time_text.dart';")
add_import('lib/features/market/presentation/widgets/hypermarket_mini_card.dart', "import 'package:food_user_app/core/widgets/delivery_time_text.dart';")

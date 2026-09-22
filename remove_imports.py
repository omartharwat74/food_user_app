with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'r') as f:
    lines = f.readlines()

new_lines = []
for line in lines:
    if "import 'package:flutter_bloc/flutter_bloc.dart';" in line: continue
    if "import 'package:food_user_app/core/di/injection_container.dart';" in line: continue
    if "import 'package:food_user_app/features/restaurant/presentation/cubit/restaurant_detail_cubit.dart';" in line: continue
    if "import 'package:food_user_app/features/restaurant/presentation/cubit/restaurant_detail_state.dart';" in line: continue
    new_lines.append(line)

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'w') as f:
    f.writelines(new_lines)

import re

# 1. Remove from HomeScreen
home_path = 'lib/features/home/presentation/pages/home_screen.dart'
with open(home_path, 'r', encoding='utf-8') as f:
    home_content = f.read()

home_content = re.sub(
    r"return MultiBlocProvider\(\s*providers: \[\s*BlocProvider<SectionsCubit>\(\s*create: \(context\) => sl<SectionsCubit>\(\)\.\.fetchSections\(\),\s*\),\s*BlocProvider<SpotlightsCubit>\(\s*create: \(context\) => sl<SpotlightsCubit>\(\)\.\.fetchSpotlights\(\),\s*\),\s*\],\s*child: Scaffold\(",
    r"return Scaffold(",
    home_content
)

with open(home_path, 'w', encoding='utf-8') as f:
    f.write(home_content)

# 2. Add to app.dart
app_path = 'lib/app.dart'
with open(app_path, 'r', encoding='utf-8') as f:
    app_content = f.read()

providers = """
        BlocProvider<SectionsCubit>(
          create: (_) => sl<SectionsCubit>()..fetchSections(),
        ),
        BlocProvider<SpotlightsCubit>(
          create: (_) => sl<SpotlightsCubit>()..fetchSpotlights(),
        ),
"""

app_content = app_content.replace("BlocProvider<BannerCubit>(", providers + "        BlocProvider<BannerCubit>(")

if "import 'package:food_user_app/features/home/presentation/cubit/home_cubits.dart';" not in app_content:
    app_content = app_content.replace("import 'package:food_user_app/features/home/presentation/cubit/banner_cubit.dart';", "import 'package:food_user_app/features/home/presentation/cubit/banner_cubit.dart';\nimport 'package:food_user_app/features/home/presentation/cubit/home_cubits.dart';")

with open(app_path, 'w', encoding='utf-8') as f:
    f.write(app_content)

# 3. Add CartCubit import to MainLayout
main_path = 'lib/features/main/presentation/pages/main_layout.dart'
with open(main_path, 'r', encoding='utf-8') as f:
    main_content = f.read()

if "import 'package:food_user_app/features/cart/presentation/cubit/cart_cubit.dart';" not in main_content:
    main_content = main_content.replace("import 'package:food_user_app/core/localization/app_locale_scope.dart';", "import 'package:food_user_app/core/localization/app_locale_scope.dart';\nimport 'package:food_user_app/features/cart/presentation/cubit/cart_cubit.dart';")

with open(main_path, 'w', encoding='utf-8') as f:
    f.write(main_content)

print("Moved providers and added import.")

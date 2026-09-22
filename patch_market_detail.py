with open('lib/features/market/presentation/pages/market_details_screen.dart', 'r') as f:
    content = f.read()

if 'import \'package:food_user_app/features/cart/presentation/widgets/cart_floating_banner.dart\';' not in content:
    content = content.replace("import 'package:food_user_app/l10n/app_localizations.dart';", "import 'package:food_user_app/l10n/app_localizations.dart';\nimport 'package:food_user_app/features/cart/presentation/widgets/cart_floating_banner.dart';")

content = content.replace("      child: Scaffold(\n        backgroundColor: AppColors.scaffoldBackground(context),\n        body:", "      child: Scaffold(\n        backgroundColor: AppColors.scaffoldBackground(context),\n        bottomNavigationBar: CartFloatingBanner(currentStoreId: widget.marketId),\n        body:")

with open('lib/features/market/presentation/pages/market_details_screen.dart', 'w') as f:
    f.write(content)

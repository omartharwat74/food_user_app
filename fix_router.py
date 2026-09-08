import re

with open('lib/core/router/app_router.dart', 'r') as f:
    content = f.read()

# Remove StoreDetailsScreen import
content = re.sub(r"import\s+['\"].*?store_details_screen\.dart['\"];\n", "", content)

# Remove RouteNames.storeDetail block
# It looks like:
#       GoRoute(
#         path: RouteNames.storeDetail,
#         builder: (c, s) => StoreDetailsScreen(
#           storeId: s.pathParameters['id'] ?? 'store-id',
#         ),
#       ),
content = re.sub(r"\s*GoRoute\(\s*path:\s*RouteNames\.storeDetail,[\s\S]*?builder:\s*\(c,\s*s\)\s*=>\s*StoreDetailsScreen\([\s\S]*?\),\s*\),", "", content)

with open('lib/core/router/app_router.dart', 'w') as f:
    f.write(content)

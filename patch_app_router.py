with open('lib/core/router/app_router.dart', 'r') as f:
    content = f.read()

content = content.replace('GoRoute(path: RouteNames.home, builder: (c, s) => const MainLayout()),', 'GoRoute(path: RouteNames.home, builder: (c, s) => MainLayout(key: MainLayout.globalKey)),')

with open('lib/core/router/app_router.dart', 'w') as f:
    f.write(content)

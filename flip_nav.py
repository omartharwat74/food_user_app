with open('lib/features/cart/presentation/widgets/cart_floating_banner.dart', 'r') as f:
    content = f.read()
    
content = content.replace("""                  context.go(RouteNames.home);
                  MainLayout.globalKey.currentState?.changeIndex(1);""", """                  MainLayout.globalKey.currentState?.changeIndex(1);
                  while (context.canPop()) {
                    context.pop();
                  }""")

with open('lib/features/cart/presentation/widgets/cart_floating_banner.dart', 'w') as f:
    f.write(content)

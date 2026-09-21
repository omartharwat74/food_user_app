import re

with open('lib/features/cart/presentation/pages/cart_screen.dart', 'r') as f:
    content = f.read()

init_state = """
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartCubit>().loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {"""

content = re.sub(r'  @override\n  Widget build\(BuildContext context\) \{', init_state, content)

with open('lib/features/cart/presentation/pages/cart_screen.dart', 'w') as f:
    f.write(content)


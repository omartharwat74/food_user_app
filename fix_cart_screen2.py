import re

with open('lib/features/cart/presentation/pages/cart_screen.dart', 'r') as f:
    content = f.read()

bad_block = """  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isActive) {
        context.read<CartCubit>().loadCart();
      }
    });
  }

  @override
  void didUpdateWidget(covariant CartScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      context.read<CartCubit>().loadCart();
    }
  }

  @override
  Widget build(BuildContext context) {"""

# Find all occurrences of bad_block and replace all except the first one with just the build method
parts = content.split(bad_block)

new_content = parts[0] + bad_block
for i in range(1, len(parts) - 1):
    new_content += parts[i] + """  @override
  Widget build(BuildContext context) {"""

new_content += parts[-1]

with open('lib/features/cart/presentation/pages/cart_screen.dart', 'w') as f:
    f.write(new_content)


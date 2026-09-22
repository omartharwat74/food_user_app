with open('lib/app.dart', 'r') as f:
    content = f.read()

content = content.replace("sl<CartCubit>(), // ..loadCart() Temporarily disabled until Cart API is ready", "sl<CartCubit>()..loadCart(),")

with open('lib/app.dart', 'w') as f:
    f.write(content)

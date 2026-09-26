filepath = 'lib/features/cart/presentation/cubit/cart_cubit.dart'
with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

old_logic = """if (failure.message.contains('CART_STORE_CONFLICT') ||
            failure.message.contains('السلة تحتوي منتجات من متجر آخر')) {"""

new_logic = """final msg = failure.message.toLowerCase();
        if (msg.contains('cart_store_conflict') ||
            msg.contains('السلة تحتوي منتجات من متجر آخر') ||
            msg.contains('another store') ||
            msg.contains('different store') ||
            msg.contains('من متجر آخر')) {"""

content = content.replace(old_logic, new_logic)

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)

print("Patched cart_cubit.dart")

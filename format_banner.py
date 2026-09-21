import re

with open('lib/features/cart/presentation/widgets/cart_floating_banner.dart', 'r') as f:
    content = f.read()

# I'll just rewrite the builder to exactly match the user's requested whitespace and syntax.
new_builder = """    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final cart = state.maybeWhen(
          loaded: (c, _) => c,
          orElse: () => null,
        );
        
        if (cart != null && cart.items.isNotEmpty) {
          final totalItems = cart.items.fold<int>(0, (sum, item) => sum + item.quantity);
          
          return Container(
            color: AppColors.surfaceCard(context),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: SafeArea(
              top: false,
              child: InkWell(
                onTap: () => context.push(RouteNames.cart),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary, // #A3090F
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'اطلع على السلة',
                        style: AppTextStyles.body(context).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          totalItems.toString(),
                          style: AppTextStyles.body(context).copyWith(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        
        return const SizedBox.shrink();
      },
    );"""

content = re.sub(r'    return BlocBuilder<CartCubit, CartState>\([\s\S]*?    \);', new_builder, content)

with open('lib/features/cart/presentation/widgets/cart_floating_banner.dart', 'w') as f:
    f.write(content)


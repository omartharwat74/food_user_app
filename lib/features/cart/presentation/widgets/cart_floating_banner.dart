import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/features/main/presentation/pages/main_layout.dart';

class CartFloatingBanner extends StatelessWidget {
  const CartFloatingBanner({required this.currentStoreId, super.key});

  final String currentStoreId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final cart = state.maybeWhen(
          loaded: (c, _) => c,
          orElse: () => null,
        );
        
        if (cart != null && cart.items.isNotEmpty && cart.restaurantId == currentStoreId) {
          final totalItems = cart.items.fold<int>(0, (sum, item) => sum + item.quantity);
          
          return Container(
            color: AppColors.surfaceCard(context),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: SafeArea(
              top: false,
              child: InkWell(
                onTap: () {
                  MainLayout.globalKey.currentState?.changeIndex(1);
                  while (context.canPop()) {
                    context.pop();
                  }
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                      const SizedBox(width: 8),
                      Text(
                        'اطلع على السلة',
                        style: AppTextStyles.body(context).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
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
    );
  }
}

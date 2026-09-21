import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/keyboard_dismiss_on_tap.dart';
import 'package:food_user_app/features/cart/domain/entities/cart.dart';
import 'package:food_user_app/features/cart/domain/entities/cart_item.dart';
import 'package:food_user_app/features/cart/presentation/widgets/cart_item_tile.dart';
import 'package:food_user_app/features/cart/presentation/widgets/cart_summary.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_state.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, this.isActive = true});

  final bool isActive;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {


  @override
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: KeyboardDismissOnTap(
        child: SafeArea(
          bottom: false,
          child: BlocListener<CartCubit, CartState>(
            listener: (context, state) {
              state.maybeWhen(
                error: (cart, promo, message) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: AppColors.error,
                    ),
                  );
                },
                orElse: () {},
              );
            },
            child: BlocBuilder<CartCubit, CartState>(
              builder: (context, state) {
                final isLoading = state.maybeWhen(
                  loading: () => true,
                  orElse: () => false,
                );

                final cart = state.maybeWhen(
                  loaded: (c, promo) => c,
                  error: (c, promo, message) => c,
                  orElse: () => const Cart.empty(),
                );

                if (isLoading && cart.items.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final subtotal = cart.subtotal.round();
                final delivery = cart.deliveryFee.round();
                final tax = cart.tax.round();
                final discount = cart.discount.round();
                final total = cart.total.round();

                return CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    SliverPadding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 0),
                      sliver: SliverToBoxAdapter(
                        child: _CartHeader(
                          l10n: l10n,
                          restaurantName: cart.restaurantName,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 28, 16, 0),
                      sliver: cart.items.isEmpty
                          ? SliverFillRemaining(
                              hasScrollBody: false,
                              child: _CartEmptyPlaceholder(l10n: l10n),
                            )
                          : SliverList.separated(
                              itemCount: cart.items.length,
                              itemBuilder: (context, index) {
                                final item = cart.items[index];
                                return CartItemTile(
                                  item: item,
                                  onEdit: () => _openProductDetails(item),
                                  onIncrement: () {
                                    context
                                        .read<CartCubit>()
                                        .updateItemQuantity(
                                          item.id,
                                          item.quantity + 1,
                                        );
                                  },
                                  onDecrement: () {
                                    context
                                        .read<CartCubit>()
                                        .updateItemQuantity(
                                          item.id,
                                          item.quantity - 1,
                                        );
                                  },
                                );
                              },
                              separatorBuilder: (_, _) => Divider(
                                height: 32,
                                thickness: 0.5,
                                color: AppColors.border(context),
                              ),
                            ),
                    ),
                    if (cart.items.isNotEmpty)
                      SliverToBoxAdapter(
                        child: CartSummary(
                          subtotal: subtotal,
                          delivery: delivery,
                          tax: tax,
                          discount: discount,
                          total: total,
                          onCheckout: _openCheckout,
                          onAddMore: () {
                            if (cart.restaurantId != null) {
                              context.push(
                                RouteNames.restaurantDetailFor(
                                  cart.restaurantId!,
                                ),
                              );
                            } else {
                              context.pop();
                            }
                          },
                          onApplyPromo: (code) {
                            context.read<CartCubit>().applyPromoCode(code);
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _openProductDetails(CartItem item) {
    context.push(RouteNames.productDetails, extra: item);
  }

  Future<void> _openCheckout() async {
    final completed = await context.push<bool>(RouteNames.checkout);
    if (!mounted || completed != true) return;

    // Clear cart upon successful checkout
    context.read<CartCubit>().clearCart();
  }
}

class _CartEmptyPlaceholder extends StatelessWidget {
  const _CartEmptyPlaceholder({required this.l10n});

  final AppLocalizations l10n;



  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 64, 16, 64),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppAssets.paymentEmptyIcon,
              width: 80,
              height: 80,
            ),
            const SizedBox(height: 20),
            Text(
              l10n.cartEmptyTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.heading4(context).copyWith(
                color: AppColors.onSurface(context),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartHeader extends StatelessWidget {
  const _CartHeader({required this.l10n, this.restaurantName});

  final AppLocalizations l10n;
  final String? restaurantName;



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              l10n.cartTitle,
              textAlign: TextAlign.start,
              style: AppTextStyles.heading4(context).copyWith(
                color: AppColors.onSurface(context),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

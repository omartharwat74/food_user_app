import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/keyboard_dismiss_on_tap.dart';
import 'package:food_user_app/core/widgets/top_snackbar.dart';
import 'package:food_user_app/features/cart/domain/entities/cart.dart';
import 'package:food_user_app/features/cart/presentation/widgets/cart_item_tile.dart';
import 'package:food_user_app/features/cart/presentation/widgets/cart_summary.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:food_user_app/features/profile/presentation/controllers/saved_addresses_scope.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, this.isActive = true});

  final bool isActive;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isSelfPickup = false;
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isActive) {
        context.read<CartCubit>().loadCart();
        try {
          SavedAddressesScope.of(context).loadAddressesIfNeeded();
        } catch (_) {}
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
                  showTopSnackBar(context, message, isError: true);
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
                  loaded: (c, promo, _) => c,
                  error: (c, promo, message) => c,
                  orElse: () => const Cart.empty(),
                );

                final isUpdating = state.maybeWhen(
                  loaded: (_, _, updatingId) => updatingId != null,
                  orElse: () => false,
                );

                if (isLoading && cart.items.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final subtotal = cart.subtotal;
                final delivery = cart.deliveryFee;
                final tax = cart.tax;
                final discount = cart.discount;
                final total = cart.total;

                return CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        16,
                        20,
                        16,
                        0,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: _CartHeader(
                          l10n: l10n,
                          restaurantName:
                              cart.items.isNotEmpty ? cart.restaurantName : null,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        16,
                        28,
                        16,
                        0,
                      ),
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
                                  onIncrement: () {
                                    context
                                        .read<CartCubit>()
                                        .updateItemQuantity(
                                          item.id,
                                          item.quantity + 1,
                                          productId: item.productId,
                                        );
                                  },
                                  onDecrement: () {
                                    context
                                        .read<CartCubit>()
                                        .updateItemQuantity(
                                          item.id,
                                          item.quantity - 1,
                                          productId: item.productId,
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
                    if (cart.items.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: CartSummary(
                          subtotal: subtotal,
                          delivery: delivery,
                          tax: tax,
                          discount: discount,
                          total: total,
                          isUpdating: isUpdating,
                          isSelfPickup: _isSelfPickup,
                          appliedPromoCode: state.maybeWhen(
                            loaded: (_, promo, _) => promo?.code,
                            orElse: () => null,
                          ),
                          onToggleSelfPickup: (selfPickup) {
                            setState(() => _isSelfPickup = selfPickup);
                            context.read<CartCubit>().setSelfPickup(selfPickup);
                          },
                          notesController: _notesController,
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
                          onApplyPromo: (code) => _handleApplyCoupon(code),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleApplyCoupon(String code) async {
    final l10n = AppLocalizations.of(context)!;
    int? addressId;

    if (!_isSelfPickup) {
      try {
        final addressesController = SavedAddressesScope.of(context);
        final selected = addressesController.selectedAddress ??
            (addressesController.addresses.isNotEmpty
                ? addressesController.addresses.first
                : null);
        if (selected != null) {
          addressId = int.tryParse(selected.id);
        }
      } catch (_) {}

      if (addressId == null) {
        showTopSnackBar(
          context,
          l10n.pleaseSelectDeliveryAddress,
          isError: true,
        );
        return;
      }
    }

    final success = await context.read<CartCubit>().applyPromoCode(
          code,
          selfPickup: _isSelfPickup,
          addressId: _isSelfPickup ? null : addressId,
        );

    if (!mounted) return;

    if (success) {
      showTopSnackBar(
        context,
        l10n.couponAppliedSuccess,
        isError: false,
      );
    }
  }

  Future<void> _openCheckout() async {
    final state = context.read<CartCubit>().state;
    final isUpdating = state.maybeWhen(
      loaded: (_, _, updatingId) => updatingId != null,
      orElse: () => false,
    );
    if (isUpdating) return;

    final couponCode = state.maybeWhen(
      loaded: (_, promo, _) => promo?.code,
      orElse: () => null,
    );
    final note = _notesController.text.trim();
    final completed = await context.push<bool>(
      RouteNames.checkout,
      extra: {
        'couponCode': couponCode,
        'note': note.isNotEmpty ? note : null,
      },
    );
    if (!mounted || completed != true) return;

    // Clear local cart upon successful checkout
    _notesController.clear();
    context.read<CartCubit>().clearLocalCart();
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
              colorFilter: ColorFilter.mode(
                AppColors.paragraph(context),
                BlendMode.srcIn,
              ),
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
    final name = restaurantName?.trim();
    final hasRestaurant = name != null && name.isNotEmpty;

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
        if (hasRestaurant) ...[
          const SizedBox(height: 4),
          Text(
            l10n.cartRestaurantSubtitle(name),
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.subtitle(context).copyWith(
              color: AppColors.paragraph(context),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }
}

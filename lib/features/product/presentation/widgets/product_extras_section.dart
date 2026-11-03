import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/utils/extensions/context_ext.dart';
import 'package:food_user_app/core/utils/price_extension.dart';
import 'package:food_user_app/features/cart/domain/entities/cart.dart';
import 'package:food_user_app/features/cart/domain/entities/cart_extra_item.dart';
import 'package:food_user_app/features/cart/domain/entities/cart_item.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_extras_cubit.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_extras_state.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

class ProductExtrasSection extends StatelessWidget {
  const ProductExtrasSection({super.key});

  @override
  Widget build(BuildContext context) {
    CartExtrasCubit? cubit;
    try {
      cubit = context.read<CartExtrasCubit>();
    } catch (_) {}

    if (cubit == null) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<CartExtrasCubit, CartExtrasState>(
      builder: (context, state) {
        if (state.items.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsetsDirectional.only(top: 20),
          width: double.infinity,
          padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 20),
          color: AppColors.surfaceCard(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.productAddSomethingTitle,
                textAlign: TextAlign.start,
                style: AppTextStyles.heading4(context).copyWith(
                  color: AppColors.onSurface(context),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.productAddSomethingSubtitle,
                textAlign: TextAlign.start,
                style: AppTextStyles.caption(context).copyWith(
                  color: AppColors.paragraph(context),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 172,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.items.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return _ProductExtraCard(
                      key: ValueKey(item.id),
                      item: item,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProductExtraCard extends StatefulWidget {
  const _ProductExtraCard({
    super.key,
    required this.item,
  });

  final CartExtraItem item;

  @override
  State<_ProductExtraCard> createState() => _ProductExtraCardState();
}

class _ProductExtraCardState extends State<_ProductExtraCard> {
  int? _optimisticQuantity;
  Timer? _debounceTimer;
  bool _isSyncing = false;
  late CartCubit _cartCubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cartCubit = context.read<CartCubit>();
  }

  @override
  void dispose() {
    if (_debounceTimer?.isActive == true && _optimisticQuantity != null) {
      _debounceTimer?.cancel();
      _syncPending(_optimisticQuantity!);
    } else {
      _debounceTimer?.cancel();
    }
    super.dispose();
  }

  CartItem? _findCartItem(Cart? cart) {
    if (cart == null) return null;
    for (final ci in cart.items) {
      if (ci.productId == widget.item.id ||
          ci.menuItemId == widget.item.id.toString()) {
        return ci;
      }
    }
    return null;
  }

  void _onIncrement(int currentQuantity) {
    final nextQuantity = (_optimisticQuantity ?? currentQuantity) + 1;
    setState(() {
      _optimisticQuantity = nextQuantity;
    });
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 350), _triggerSync);
  }

  void _onDecrement(int currentQuantity) {
    final current = _optimisticQuantity ?? currentQuantity;
    if (current <= 0) return;
    final nextQuantity = current - 1;
    setState(() {
      _optimisticQuantity = nextQuantity;
    });
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 350), _triggerSync);
  }

  Future<void> _triggerSync() async {
    if (!mounted) return;
    if (_isSyncing) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 150), _triggerSync);
      return;
    }

    final target = _optimisticQuantity;
    if (target == null) return;

    final currentCart = _cartCubit.state.maybeWhen(
      loaded: (c, _, _) => c,
      orElse: () => null,
    );
    final cartItem = _findCartItem(currentCart);
    final serverQty = cartItem?.quantity ?? 0;

    if (target == serverQty) {
      if (mounted && (_debounceTimer == null || !_debounceTimer!.isActive)) {
        setState(() => _optimisticQuantity = null);
      }
      return;
    }

    _isSyncing = true;
    try {
      if (target == 0) {
        if (cartItem != null) {
          await _cartCubit.updateItemQuantity(
            cartItem.id,
            0,
            productId: widget.item.id,
          );
        }
      } else if (cartItem != null) {
        await _cartCubit.updateItemQuantity(
          cartItem.id,
          target,
          productId: widget.item.id,
        );
      } else {
        await _cartCubit.addItem(
          productId: widget.item.id.toString(),
          quantity: target,
          optionValueIds: const [],
        );
      }
    } catch (_) {
      // Cart errors handled by CartCubit
    } finally {
      _isSyncing = false;
      if (mounted) {
        if (_debounceTimer == null || !_debounceTimer!.isActive) {
          setState(() {
            _optimisticQuantity = null;
          });
        }
      }
    }
  }

  void _syncPending(int targetQuantity) {
    try {
      final currentCart = _cartCubit.state.maybeWhen(
        loaded: (c, _, _) => c,
        orElse: () => null,
      );
      final cartItem = _findCartItem(currentCart);
      final serverQty = cartItem?.quantity ?? 0;
      if (targetQuantity == serverQty) return;

      if (targetQuantity == 0) {
        if (cartItem != null) {
          _cartCubit.updateItemQuantity(
            cartItem.id,
            0,
            productId: widget.item.id,
          );
        }
      } else if (cartItem != null) {
        _cartCubit.updateItemQuantity(
          cartItem.id,
          targetQuantity,
          productId: widget.item.id,
        );
      } else {
        _cartCubit.addItem(
          productId: widget.item.id.toString(),
          quantity: targetQuantity,
          optionValueIds: const [],
        );
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final image = widget.item.mainImage?.trim() ?? '';

    final cart = context.watch<CartCubit>().state.maybeWhen(
      loaded: (c, _, _) => c,
      orElse: () => null,
    );
    final cartItem = _findCartItem(cart);
    final serverQuantity = cartItem?.quantity ?? 0;
    final displayQuantity = _optimisticQuantity ?? serverQuantity;

    return Container(
      width: 134,
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border(context), width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: isDark
                        ? const Color(0xFF1E1E1E)
                        : const Color(0xFFF9F9F9),
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: image.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: image,
                              fit: BoxFit.contain,
                              errorWidget: (_, _, _) => Image.asset(
                                AppAssets.productAddonToast,
                                fit: BoxFit.contain,
                              ),
                            )
                          : Image.asset(
                              AppAssets.productAddonToast,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                ),
                PositionedDirectional(
                  end: 8,
                  bottom: 8,
                  child: displayQuantity > 0
                      ? _buildCounter(displayQuantity)
                      : _buildAddButton(),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 0.5,
            color: AppColors.border(context),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 8, 10, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption(context).copyWith(
                    color: AppColors.onSurface(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.priceWithCurrency(
                        widget.item.priceAfterDiscount.toFormattedPrice(),
                      ),
                      style: AppTextStyles.textLink(context).copyWith(
                        color: AppColors.onSurface(context),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                    if (widget.item.hasDiscount)
                      Text(
                        AppLocalizations.of(context)!.priceWithCurrency(
                          widget.item.basePrice.toFormattedPrice(),
                        ),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.lineThrough,
                          color: AppColors.paragraph(context),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      key: ValueKey('extra_add_${widget.item.id}'),
      behavior: HitTestBehavior.opaque,
      onTap: () => _onIncrement(0),
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surfaceCard(context),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SvgPicture.asset(
          AppAssets.cartPlusIcon,
          width: 18,
          height: 18,
        ),
      ),
    );
  }

  Widget _buildCounter(int quantity) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.border(context),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            key: ValueKey('extra_increment_${widget.item.id}'),
            behavior: HitTestBehavior.opaque,
            onTap: () => _onIncrement(quantity),
            child: Container(
              width: 28,
              height: 30,
              alignment: Alignment.center,
              child: SvgPicture.asset(
                AppAssets.cartPlusIcon,
                width: 14,
                height: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: SizedBox(
              width: 20,
              child: Text(
                '$quantity',
                textAlign: TextAlign.center,
                style: AppTextStyles.body(context).copyWith(
                  color: AppColors.onSurface(context),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ),
          ),
          GestureDetector(
            key: ValueKey('extra_decrement_${widget.item.id}'),
            behavior: HitTestBehavior.opaque,
            onTap: () => _onDecrement(quantity),
            child: Container(
              width: 28,
              height: 30,
              alignment: Alignment.center,
              child: SvgPicture.asset(
                quantity == 1
                    ? AppAssets.cartDeleteIcon
                    : AppAssets.cartMinusIcon,
                width: 14,
                height: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

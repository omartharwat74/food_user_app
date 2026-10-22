import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/keyboard_dismiss_on_tap.dart';
import 'package:food_user_app/features/checkout/domain/entities/map_picker_result.dart';
import 'package:food_user_app/features/checkout/presentation/widgets/payment_options_section.dart';
import 'package:food_user_app/features/profile/presentation/controllers/saved_addresses_controller.dart';
import 'package:food_user_app/features/profile/presentation/controllers/saved_addresses_scope.dart';
import 'package:food_user_app/features/main/presentation/pages/main_layout.dart';
import 'package:food_user_app/features/wallet/presentation/cubit/wallet_cubit.dart';
import 'package:food_user_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:food_user_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:food_user_app/core/utils/price_extension.dart';
import 'package:food_user_app/core/widgets/app_directional_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:food_user_app/features/payment/presentation/cubit/checkout_cubit.dart';
import 'package:food_user_app/features/payment/presentation/cubit/checkout_state.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, this.couponCode});

  final String? couponCode;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  CheckoutPaymentOption _paymentOption = CheckoutPaymentOption.cash;
  MapPickerResult? _selectedAddress;

  String? get _effectiveCouponCode {
    if (widget.couponCode != null && widget.couponCode!.trim().isNotEmpty) {
      return widget.couponCode!.trim();
    }
    final cartState = context.read<CartCubit>().state;
    return cartState.maybeWhen(
      loaded: (_, promo) => promo?.code?.trim(),
      orElse: () => null,
    );
  }

  int? _getCurrentAddressId(SavedAddressesController controller) {
    final addr = controller.selectedAddress ??
        controller.addresses.where((a) => a.isDefault).firstOrNull ??
        controller.addresses.firstOrNull;
    if (addr?.id != null) {
      return int.tryParse(addr!.id);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final addressesController = SavedAddressesScope.of(context);
    if (!addressesController.hasLoaded && !addressesController.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        addressesController.loadAddressesIfNeeded();
      });
    }
    final address = addressesController.selectedAddress ??
        addressesController.addresses.where((a) => a.isDefault).firstOrNull ??
        addressesController.addresses.firstOrNull;
    final selectedSavedAddress = (address?.fullAddress?.isNotEmpty == true)
        ? address!.fullAddress
        : (address?.title(Localizations.localeOf(context)).isNotEmpty == true)
        ? address!.title(Localizations.localeOf(context))
        : null;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: KeyboardDismissOnTap(
        child: SafeArea(
          bottom: false,
          child: BlocConsumer<CheckoutCubit, CheckoutState>(
            listener: (context, checkoutState) {
              checkoutState.maybeWhen(
                success: (order) {
                  // 1. Clear cart locally
                  context.read<CartCubit>().clearLocalCart();

                  // 2. If wallet payment, refresh wallet
                  if (_paymentOption == CheckoutPaymentOption.wallet ||
                      order.paymentMethod == 'wallet') {
                    try {
                      if (context.mounted) {
                        context.read<WalletCubit>().loadWallet();
                      }
                    } catch (_) {}
                    try {
                      if (context.mounted) {
                        context.read<ProfileBloc>().add(const GetProfileEvent());
                      }
                    } catch (_) {}
                  }

                  // 3. Show success message from server
                  final isAr = Localizations.localeOf(context).languageCode == 'ar';
                  final successMsg = order.message?.isNotEmpty == true
                      ? order.message!
                      : (isAr ? 'تم إنشاء الطلب بنجاح' : 'Order created successfully');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(successMsg),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // 4. Navigate directly to "Orders" tab in bottom navigation bar and close checkout
                  MainLayout.globalKey.currentState?.changeIndex(2);
                  if (context.canPop()) {
                    context.pop(true);
                  } else {
                    context.go(RouteNames.home);
                  }
                },
                error: (message) {
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
            builder: (context, checkoutState) {
              final isPlacingOrder = checkoutState.maybeWhen(
                loading: () => true,
                orElse: () => false,
              );

              return BlocBuilder<CartCubit, CartState>(
                builder: (context, cartState) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          16,
                          20,
                          16,
                          0,
                        ),
                        child: _CheckoutHeader(title: l10n.checkoutTitle),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            16,
                            0,
                            16,
                            24,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _CurrentAddressCard(
                                address:
                                    _selectedAddress?.address ??
                                    selectedSavedAddress ??
                                    l10n.deliveryAddress,
                                onChange: _changeAddress,
                              ),
                              const SizedBox(height: 16),
                              PaymentOptionsSection(
                                selectedOption: _paymentOption,
                                onChanged: _handlePaymentOptionSelected,
                              ),
                            ],
                          ),
                        ),
                      ),
                      _CheckoutBottomBar(
                        label: l10n.checkoutConfirmOrder,
                        isLoading: isPlacingOrder,
                        onTap: isPlacingOrder
                            ? null
                            : () => _submitOrder(addressesController),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _handlePaymentOptionSelected(CheckoutPaymentOption option) {
    if (option == CheckoutPaymentOption.card ||
        option == CheckoutPaymentOption.newCard) {
      final isAr = Localizations.localeOf(context).languageCode == 'ar';
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isAr ? 'قريباً' : 'Coming Soon'),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _paymentOption = option);
  }

  void _submitOrder(SavedAddressesController addressesController) {
    final addressId = _getCurrentAddressId(addressesController);
    if (addressId == null) {
      final isAr = Localizations.localeOf(context).languageCode == 'ar';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isAr
                ? 'يرجى تحديد عنوان التوصيل'
                : 'Please select a delivery address',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final paymentMethod =
        _paymentOption == CheckoutPaymentOption.wallet ? 'wallet' : 'cash';

    context.read<CheckoutCubit>().checkout(
      paymentMethod: paymentMethod,
      addressId: addressId,
      selfPickup: false,
      couponCode: _effectiveCouponCode,
    );
  }

  Future<void> _changeAddress() async {
    final result = await context.push<Object?>(RouteNames.addressSelection);
    if (!mounted) return;
    if (result is MapPickerResult) {
      setState(() => _selectedAddress = result);
    }
    final addressesController = SavedAddressesScope.of(context);
    await addressesController.loadAddresses();
    if (mounted) setState(() {});
  }
}

class _CheckoutHeader extends StatelessWidget {
  const _CheckoutHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.pop(),
              child: SizedBox(
                width: 28,
                height: 28,
                child: Icon(
                  AppDirectionalIcons.backChevron(context),
                  size: 28,
                  color: AppColors.onSurface(context),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: AppTextStyles.appBarTitle(context).copyWith(
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

class _CurrentAddressCard extends StatelessWidget {
  const _CurrentAddressCard({required this.address, required this.onChange});

  final String address;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border(context), width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.selectedLocation,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: AppTextStyles.body(context).copyWith(
                          color: AppColors.onSurface(context),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppAssets.addressLocationIcon,
                            width: 16,
                            height: 16,
                            colorFilter: const ColorFilter.mode(
                              AppColors.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              address,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style: AppTextStyles.caption(context).copyWith(
                                color: AppColors.paragraph(context),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onChange,
                  child: Text(
                    l10n.checkoutChangeAddress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: AppTextStyles.textLink(context).copyWith(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.25,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Expanded(child: _MapStrip()),
        ],
      ),
    );
  }
}

class _MapStrip extends StatelessWidget {
  const _MapStrip();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(AppAssets.addressMapPreview, fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: ColoredBox(color: AppColors.black.withValues(alpha: 0.20)),
        ),
      ],
    );
  }
}

class _CheckoutBottomBar extends StatefulWidget {
  const _CheckoutBottomBar({
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  State<_CheckoutBottomBar> createState() => _CheckoutBottomBarState();
}

class _CheckoutBottomBarState extends State<_CheckoutBottomBar> {
  bool isSummaryExpanded = false;

  Widget _buildSummaryRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1B1B1B),
              fontSize: 14,
              fontFamily: 'Expo Arabic',
              fontWeight: FontWeight.w500,
              height: 1.30,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1B1B1B),
              fontSize: 14,
              fontFamily: 'Expo Arabic',
              fontWeight: FontWeight.w500,
              height: 1.30,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final cart = state.maybeWhen(
          loaded: (cart, promo) => cart,
          error: (cart, promo, message) => cart,
          orElse: () => null,
        );

        final subtotal = cart?.subtotal ?? 0.0;
        final deliveryFee = cart?.deliveryFee ?? 0.0;
        final tax = cart?.tax ?? 0.0;
        final discount = cart?.discount ?? 0.0;
        final total = cart?.total ?? 0.0;

        return Container(
          width: double.infinity,
          padding: EdgeInsetsDirectional.fromSTEB(
            16,
            16,
            16,
            bottomSafe > 0 ? bottomSafe : 16,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard(context),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.08),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: isSummaryExpanded
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.orderSummary,
                            style: const TextStyle(
                              color: Color(0xFF1B1B1B),
                              fontSize: 16,
                              fontFamily: 'Expo Arabic',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryRow(
                            context,
                            AppLocalizations.of(context)!.orderValue,
                            AppLocalizations.of(
                              context,
                            )!.priceWithCurrency(subtotal.toFormattedPrice()),
                          ),
                          _buildSummaryRow(
                            context,
                            AppLocalizations.of(context)!.delivery,
                            AppLocalizations.of(context)!.priceWithCurrency(
                              deliveryFee.toFormattedPrice(),
                            ),
                          ),
                          _buildSummaryRow(
                            context,
                            AppLocalizations.of(context)!.tax,
                            AppLocalizations.of(
                              context,
                            )!.priceWithCurrency(tax.toFormattedPrice()),
                          ),
                          _buildSummaryRow(
                            context,
                            AppLocalizations.of(context)!.discount,
                            AppLocalizations.of(
                              context,
                            )!.priceWithCurrency(discount.toFormattedPrice()),
                          ),
                          const Divider(
                            color: Color(0xFFE5E5E5),
                            thickness: 0.5,
                            height: 0.5,
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isSummaryExpanded = !isSummaryExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.total} ${AppLocalizations.of(context)!.priceWithCurrency(total.toFormattedPrice())}',
                        style: const TextStyle(
                          color: Color(0xFF1B1B1B),
                          fontSize: 16,
                          fontFamily: 'Expo Arabic',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        isSummaryExpanded
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                        color: const Color(0xFF1B1B1B),
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.isLoading ? null : widget.onTap,
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: widget.isLoading
                        ? AppColors.primary.withValues(alpha: 0.6)
                        : AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: widget.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          widget.label,
                          style: AppTextStyles.primaryButtonLabel.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

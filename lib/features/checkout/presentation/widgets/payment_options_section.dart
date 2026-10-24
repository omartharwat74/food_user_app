import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/utils/extensions/context_ext.dart';

enum CheckoutPaymentOption { newCard, card, wallet, cash }

class PaymentOptionsSection extends StatelessWidget {
  const PaymentOptionsSection({
    required this.selectedOption,
    required this.onChanged,
    super.key,
  });

  final CheckoutPaymentOption selectedOption;
  final ValueChanged<CheckoutPaymentOption> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final iconColor =
        Theme.of(context).iconTheme.color ?? AppColors.onSurface(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.checkoutPaymentMethod,
          textAlign: TextAlign.start,
          style: AppTextStyles.heading4(context).copyWith(
            color: AppColors.onSurface(context),
            fontSize: 15,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 12),
        _PaymentOptionTile(
          title: l10n.addNewCard,
          selected: selectedOption == CheckoutPaymentOption.newCard,
          icon: Icon(
            Icons.add_circle_outline_rounded,
            size: 20,
            color: iconColor,
          ),
          onTap: () => onChanged(CheckoutPaymentOption.newCard),
        ),
        const SizedBox(height: 12),
        _PaymentOptionTile(
          title: l10n.checkoutCardPayment,
          selected: selectedOption == CheckoutPaymentOption.card,
          icon: SvgPicture.asset(
            AppAssets.paymentCreditCardIcon,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(
              iconColor,
              BlendMode.srcIn,
            ),
          ),
          onTap: () => onChanged(CheckoutPaymentOption.card),
        ),
        const SizedBox(height: 12),
        _PaymentOptionTile(
          title: l10n.checkoutWalletPayment,
          selected: selectedOption == CheckoutPaymentOption.wallet,
          icon: Image.asset(
            AppAssets.paymentWalletIcon,
            width: 20,
            height: 20,
            fit: BoxFit.contain,
            color: iconColor,
          ),
          onTap: () => onChanged(CheckoutPaymentOption.wallet),
        ),
        const SizedBox(height: 12),
        _PaymentOptionTile(
          title: l10n.checkoutCashOnDelivery,
          selected: selectedOption == CheckoutPaymentOption.cash,
          icon: SvgPicture.asset(
            AppAssets.paymentCashIcon,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(
              iconColor,
              BlendMode.srcIn,
            ),
          ),
          onTap: () => onChanged(CheckoutPaymentOption.cash),
        ),
      ],
    );
  }
}

class _PaymentOptionTile extends StatelessWidget {
  const _PaymentOptionTile({
    required this.title,
    required this.selected,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsetsDirectional.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.border(context),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: _PaymentOptionLabel(title: title, icon: icon),
            ),
            const SizedBox(width: 12),
            _PaymentRadio(selected: selected),
          ],
        ),
      ),
    );
  }
}

class _PaymentOptionLabel extends StatelessWidget {
  const _PaymentOptionLabel({required this.title, required this.icon});

  final String title;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            style: AppTextStyles.body(context).copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color ??
                  AppColors.onSurface(context),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentRadio extends StatelessWidget {
  const _PaymentRadio({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final selectedColor =
        Theme.of(context).iconTheme.color ?? AppColors.onSurface(context);

    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? selectedColor : AppColors.paragraph(context),
          width: 1,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: selectedColor,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}

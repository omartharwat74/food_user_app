import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:food_user_app/core/utils/price_extension.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({
    required this.subtotal,
    required this.delivery,
    required this.tax,
    required this.discount,
    required this.total,
    required this.onCheckout,
    required this.onAddMore,
    this.onApplyPromo,
    super.key,
  });

  final double subtotal;
  final double delivery;
  final double tax;
  final double discount;
  final double total;
  final VoidCallback onCheckout;
  final VoidCallback onAddMore;
  final ValueChanged<String>? onApplyPromo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 22),
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 20),
      color: AppColors.surfaceCard(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _NotesBox(hint: l10n.cartNotesHint),
          const SizedBox(height: 16),
          _DiscountBox(l10n: l10n, onApply: onApplyPromo),
          const SizedBox(height: 18),
          Text(
            l10n.paymentSummary,
            textAlign: TextAlign.start,
            style: AppTextStyles.heading4(context).copyWith(
              color: AppColors.onSurface(context),
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            label: l10n.orderSubtotal,
            value: l10n.cartPrice((subtotal).toFormattedPrice()),
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            label: l10n.orderDeliveryFee,
            value: l10n.cartPrice((delivery).toFormattedPrice()),
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            label: AppLocalizations.of(context)!.tax,
            value: l10n.cartPrice((tax).toFormattedPrice()),
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            label: l10n.orderDiscount,
            value: l10n.cartPrice((discount).toFormattedPrice()),
          ),
          const SizedBox(height: 12),
          Divider(height: 1, thickness: 0.5, color: AppColors.border(context)),
          const SizedBox(height: 12),
          _SummaryRow(
            label: l10n.orderGrandTotal,
            value: l10n.cartPrice((total).toFormattedPrice()),
            emphasized: true,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _OutlineButton(
                  label: l10n.cartAddMore,
                  onTap: onAddMore,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _PrimaryButton(
                  label: l10n.cartCheckout,
                  onTap: onCheckout,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NotesBox extends StatelessWidget {
  const _NotesBox({required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border(context), width: 0.5),
      ),
      child: TextField(
        minLines: 1,
        maxLines: 2,
        textAlign: TextAlign.start,
        textInputAction: TextInputAction.newline,
        cursorColor: AppColors.cursor(context),
        style: AppTextStyles.inputText(
          context,
        ).copyWith(fontSize: 12, height: 1.3),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.caption(
            context,
          ).copyWith(color: AppColors.hint(context), fontSize: 12, height: 1.3),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
        ),
      ),
    );
  }
}

class _DiscountBox extends StatefulWidget {
  const _DiscountBox({required this.l10n, this.onApply});

  final AppLocalizations l10n;
  final ValueChanged<String>? onApply;

  @override
  State<_DiscountBox> createState() => _DiscountBoxState();
}

class _DiscountBoxState extends State<_DiscountBox> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.55),
          width: 0.5,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textAlign: TextAlign.start,
              textInputAction: TextInputAction.done,
              cursorColor: AppColors.cursor(context),
              style: AppTextStyles.inputText(
                context,
              ).copyWith(fontSize: 12, height: 1.3),
              decoration: InputDecoration(
                hintText: widget.l10n.cartDiscountCode,
                hintStyle: AppTextStyles.caption(context).copyWith(
                  color: AppColors.hint(context),
                  fontSize: 12,
                  height: 1.3,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsetsDirectional.zero,
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              final code = _controller.text.trim();
              if (code.isNotEmpty && widget.onApply != null) {
                widget.onApply!(code);
              }
            },
            child: Container(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                widget.l10n.addCard,
                style: AppTextStyles.textLink(context).copyWith(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.body(context).copyWith(
      color: AppColors.onSurface(context),
      fontSize: emphasized ? 14 : 12,
      fontWeight: emphasized ? FontWeight.w500 : FontWeight.w400,
      height: emphasized ? 1.25 : 1.3,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, textAlign: TextAlign.start, style: style),
        Text(value, style: style),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: AppTextStyles.buttonHeading(context).copyWith(
            color: AppColors.text,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.25,
          ),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary, width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(AppAssets.cartPlusIcon, width: 20, height: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.buttonHeading(context).copyWith(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

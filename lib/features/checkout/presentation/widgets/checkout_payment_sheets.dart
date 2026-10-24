import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/top_snackbar.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

Future<bool?> showCheckoutAddCardSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: false,
    barrierColor: AppColors.languageModalBarrier(context),
    backgroundColor: AppColors.transparent,
    builder: (_) => const _AddCardSheet(),
  );
}

Future<bool?> showCheckoutConfirmPaymentSheet(
  BuildContext context, {
  required String total,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: false,
    barrierColor: AppColors.languageModalBarrier(context),
    backgroundColor: AppColors.transparent,
    builder: (_) => _ConfirmPaymentSheet(total: total),
  );
}

class _AddCardSheet extends StatefulWidget {
  const _AddCardSheet();

  @override
  State<_AddCardSheet> createState() => _AddCardSheetState();
}

class _AddCardSheetState extends State<_AddCardSheet> {
  final _numberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  var _saveCard = true;

  @override
  void dispose() {
    _numberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomSafe = MediaQuery.paddingOf(context).bottom;
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Material(
          color: AppColors.scaffoldBackground(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                  child: _SheetHeader(title: l10n.addNewCard),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 16,
                  ),
                  child: Column(
                    children: [
                      _SheetTextField(
                        label: l10n.cardNumber,
                        hint: l10n.cardNumber,
                        controller: _numberController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _SheetTextField(
                              label: l10n.expiryDate,
                              hint: l10n.expiryDate,
                              controller: _expiryController,
                              keyboardType: TextInputType.datetime,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _SheetTextField(
                              label: l10n.cvv,
                              hint: 'cvv',
                              controller: _cvvController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _SaveCardRow(
                        selected: _saveCard,
                        onTap: () => setState(() => _saveCard = !_saveCard),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _SheetBottomBar(
                  label: l10n.addCard,
                  bottomPadding: bottomSafe + 20,
                  onTap: () {
                    final num =
                        _numberController.text.trim().replaceAll(' ', '');
                    final exp = _expiryController.text.trim();
                    final cvv = _cvvController.text.trim();

                    if (num.length < 15 || num.length > 19) {
                      showTopSnackBar(context, l10n.invalidCardNumber);
                      return;
                    }
                    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(exp)) {
                      showTopSnackBar(context, l10n.invalidExpiryDate);
                      return;
                    }
                    if (cvv.length < 3 || cvv.length > 4) {
                      showTopSnackBar(context, l10n.invalidCvv);
                      return;
                    }

                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfirmPaymentSheet extends StatefulWidget {
  const _ConfirmPaymentSheet({required this.total});

  final String total;

  @override
  State<_ConfirmPaymentSheet> createState() => _ConfirmPaymentSheetState();
}

class _ConfirmPaymentSheetState extends State<_ConfirmPaymentSheet> {
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomSafe = MediaQuery.paddingOf(context).bottom;
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Material(
          color: AppColors.scaffoldBackground(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                  child: _SheetHeader(title: l10n.checkoutCardPayment),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 16,
                  ),
                  child: _SheetTextField(
                    label: l10n.cvv,
                    hint: 'cvv',
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(height: 20),
                _ConfirmPaymentBottomBar(
                  totalLabel: l10n.orderGrandTotal,
                  total: widget.total,
                  confirmLabel: l10n.confirmPayment,
                  bottomPadding: bottomSafe + 20,
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.title});

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
              onTap: () => Navigator.of(context).pop(),
              child: SizedBox(
                width: 28,
                height: 28,
                child: Center(
                  child: SvgPicture.asset(
                    AppAssets.paymentCloseIcon,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      AppColors.onSurface(context),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
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
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetTextField extends StatelessWidget {
  const _SheetTextField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.textInputAction,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          style: AppTextStyles.footerSecondary(context).copyWith(
            color: AppColors.onSurface(context),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            textAlign: TextAlign.start,
            cursorColor: AppColors.cursor(context),
            style: AppTextStyles.inputText(
              context,
            ).copyWith(fontSize: 12, height: 1.3),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.inputHint(context).copyWith(
                color: AppColors.hint(context),
                fontSize: 12,
                height: 1.3,
              ),
              filled: true,
              fillColor: AppColors.surfaceCard(context),
              contentPadding: const EdgeInsetsDirectional.symmetric(
                horizontal: 16,
              ),
              border: _fieldBorder(context, AppColors.border(context)),
              enabledBorder: _fieldBorder(context, AppColors.border(context)),
              focusedBorder: _fieldBorder(
                context,
                AppColors.fieldFocusBorder(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _fieldBorder(BuildContext context, Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: 0.5),
    );
  }
}

class _SaveCardRow extends StatelessWidget {
  const _SaveCardRow({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primary
                  : AppColors.surfaceCard(context),
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: AppColors.primary, width: 1),
            ),
            child: selected
                ? const Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: AppColors.text,
                  )
                : null,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    l10n.saveCardDetails,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: AppTextStyles.body(context).copyWith(
                      color: AppColors.onSurface(context),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.primary, width: 1),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(bottom: 1),
                      child: Text(
                        l10n.forLaterUse,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: AppTextStyles.body(context).copyWith(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.35,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetBottomBar extends StatelessWidget {
  const _SheetBottomBar({
    required this.label,
    required this.bottomPadding,
    required this.onTap,
  });

  final String label;
  final double bottomPadding;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, bottomPadding),
      decoration: _bottomBarDecoration(context),
      child: _PrimarySheetButton(label: label, onTap: onTap),
    );
  }
}

class _ConfirmPaymentBottomBar extends StatelessWidget {
  const _ConfirmPaymentBottomBar({
    required this.totalLabel,
    required this.total,
    required this.confirmLabel,
    required this.bottomPadding,
    required this.onTap,
  });

  final String totalLabel;
  final String total;
  final String confirmLabel;
  final double bottomPadding;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final labelStyle = AppTextStyles.body(context).copyWith(
      color: AppColors.onSurface(context),
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.25,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, bottomPadding),
      decoration: _bottomBarDecoration(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(totalLabel, textAlign: TextAlign.start, style: labelStyle),
              Text(
                total,
                textAlign: TextAlign.end,
                style: labelStyle.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _PrimarySheetButton(label: confirmLabel, onTap: onTap),
        ],
      ),
    );
  }
}

class _PrimarySheetButton extends StatelessWidget {
  const _PrimarySheetButton({required this.label, required this.onTap});

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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyles.primaryButtonLabel.copyWith(
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

BoxDecoration _bottomBarDecoration(BuildContext context) {
  return BoxDecoration(
    color: AppColors.surfaceCard(context),
    boxShadow: [
      BoxShadow(color: AppColors.shadow.withValues(alpha: 0.08), blurRadius: 4),
    ],
  );
}

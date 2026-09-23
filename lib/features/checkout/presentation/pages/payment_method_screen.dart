import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/payment/presentation/cubit/payment_method_cubit.dart';
import 'package:food_user_app/features/payment/presentation/cubit/payment_method_state.dart';
import 'package:food_user_app/features/payment/domain/usecases/save_card_usecase.dart';
import 'package:food_user_app/features/payment/data/models/save_card_request_dto.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:food_user_app/core/widgets/app_directional_icons.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  static const _screenPadding = 16.0;
  static const _topInset = 20.0;
  static const _headerHeight = 28.0;
  static const _headerIconSize = 28.0;
  static const _headerGap = 4.0;
  static const _contentTopGap = 16.0;
  static const _cardGap = 12.0;
  static const _bottomBarTop = 16.0;
  static const _bottomBarBottom = 20.0;
  static const _buttonHeight = 48.0;
  static const _actionsMenuWidth = 107.0;
  static const _actionsMenuHeight = 78.0;

  @override
  void initState() {
    super.initState();
    // Fetch cards when screen opens
    context.read<PaymentMethodCubit>().fetchSavedCards();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: _screenPadding,
                top: _topInset,
                end: _screenPadding,
              ),
              child: _PaymentHeader(title: l10n.cardsTitle),
            ),
            const SizedBox(height: _contentTopGap),
            Expanded(
              child: BlocBuilder<PaymentMethodCubit, PaymentMethodState>(
                builder: (context, state) {
                  return state.when(
                    initial: () =>
                        const Center(child: CircularProgressIndicator()),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (msg) => _EmptyCardsState(message: msg),
                    loaded: (cards) {
                      if (cards.isEmpty) {
                        return _EmptyCardsState(message: l10n.noCardsMessage);
                      }
                      // Map Domain Entities to UI Data
                      final uiCards = cards.map((c) {
                        final month =
                            c.expMonth?.toString().padLeft(2, '0') ?? '--';
                        final yearRaw = c.expYear?.toString() ?? '--';
                        final year = yearRaw.length >= 4
                            ? yearRaw.substring(2)
                            : yearRaw;

                        return _PaymentCardData(
                          id: c.id,
                          holder: l10n.sampleCardHolder,
                          maskedNumber: '**** **** **** ${c.last4 ?? "****"}',
                          fullNumber: c.cardNumber,

                          expiry: '$month/$year',
                        );
                      }).toList();

                      return _CardsList(
                        cards: uiCards,
                        onMoreTap: _showCardActionsMenu,
                      );
                    },
                  );
                },
              ),
            ),
            _PaymentBottomBar(
              label: l10n.addNewCard,
              iconAsset: AppAssets.paymentAddIcon,
              onTap: _showAddCardSheet,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddCardSheet() async {
    final result = await _showCardFormSheet(isEdit: false);
    if (!mounted || result == null) return;

    final l10n = AppLocalizations.of(context)!;

    // Call Cubit to save card
    context.read<PaymentMethodCubit>().saveCard(
      SaveCardParams(
        request: SaveCardRequestDto(
          cardNumber: result.cardNumber.replaceAll(' ', ''),
          expiryDate: result.expiry,
          cvv: result.cvv,
        ),
      ),
    );
    _showDesignSnackBar(l10n.cardAddedDesignOnly);
  }

  Future<_CardFormResult?> _showCardFormSheet({
    required bool isEdit,
    _PaymentCardData? card,
  }) {
    return showModalBottomSheet<_CardFormResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      barrierColor: AppColors.languageModalBarrier(context),
      backgroundColor: AppColors.transparent,
      builder: (sheetContext) {
        return _CardFormSheet(isEdit: isEdit, card: card);
      },
    );
  }

  void _showCardActionsMenu(_PaymentCardData card, Rect anchor) {
    final barrierLabel = MaterialLocalizations.of(
      context,
    ).modalBarrierDismissLabel;
    final screenSize = MediaQuery.sizeOf(context);
    final maxLeft = screenSize.width - _actionsMenuWidth - _screenPadding;
    final maxTop = screenSize.height - _actionsMenuHeight - _screenPadding;
    final left = _clampDouble(
      anchor.left + anchor.width - _actionsMenuWidth,
      _screenPadding,
      maxLeft,
    );
    final top = _clampDouble(anchor.bottom + 8, _screenPadding, maxTop);

    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: barrierLabel,
      barrierColor: AppColors.transparent,
      transitionDuration: Duration.zero,
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(dialogContext).pop(),
                child: const SizedBox.expand(),
              ),
            ),
            Positioned(
              left: left,
              top: top,
              child: _CardActionsMenu(
                onDelete: () {
                  Navigator.of(dialogContext).pop();
                  _runAfterRoutePop(() => _showDeleteCardDialog(card));
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteCardDialog(_PaymentCardData card) {
    showDialog<void>(
      context: context,
      barrierColor: AppColors.languageModalBarrier(context),
      builder: (dialogContext) {
        return _DeleteCardDialog(
          onDelete: () {
            Navigator.of(dialogContext).pop();
            context.read<PaymentMethodCubit>().deleteCard(card.id);
            _showDesignSnackBar(
              AppLocalizations.of(context)!.cardDeletedDesignOnly,
            );
          },
        );
      },
    );
  }

  void _runAfterRoutePop(VoidCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) callback();
    });
  }

  void _showDesignSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  double _clampDouble(double value, double min, double max) {
    if (max < min) return min;
    return value.clamp(min, max).toDouble();
  }
}

class _PaymentCardData {
  const _PaymentCardData({
    required this.id,
    required this.holder,
    required this.maskedNumber,
    this.fullNumber,

    required this.expiry,

    this.usesLocalizedSample = false,
  });

  final String id;
  final String holder;
  final String maskedNumber;
  final String? fullNumber;

  final String expiry;

  final bool usesLocalizedSample;

  _PaymentCardData copyWith({
    String? holder,
    String? maskedNumber,
    String? fullNumber,

    String? expiry,
    bool? usesLocalizedSample,
  }) {
    return _PaymentCardData(
      id: id,
      holder: holder ?? this.holder,
      maskedNumber: maskedNumber ?? this.maskedNumber,
      fullNumber: fullNumber ?? this.fullNumber,

      expiry: expiry ?? this.expiry,
      usesLocalizedSample: usesLocalizedSample ?? this.usesLocalizedSample,
    );
  }
}

class _CardFormResult {
  const _CardFormResult({
    required this.cardNumber,
    required this.expiry,
    required this.cvv,
  });

  final String cardNumber;
  final String expiry;
  final String cvv;
}

class _PaymentHeader extends StatelessWidget {
  const _PaymentHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _PaymentMethodScreenState._headerHeight,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.pop(),
              child: SizedBox(
                width: _PaymentMethodScreenState._headerIconSize,
                height: _PaymentMethodScreenState._headerIconSize,
                child: Icon(
                  AppDirectionalIcons.backChevron(context),
                  size: _PaymentMethodScreenState._headerIconSize,
                  color: AppColors.onSurface(context),
                ),
              ),
            ),
            const SizedBox(width: _PaymentMethodScreenState._headerGap),
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

class _EmptyCardsState extends StatelessWidget {
  const _EmptyCardsState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(AppAssets.paymentEmptyIcon, width: 80, height: 80),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.footerSecondary(context).copyWith(
              color: AppColors.paragraph(context),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardsList extends StatelessWidget {
  const _CardsList({required this.cards, required this.onMoreTap});

  final List<_PaymentCardData> cards;
  final void Function(_PaymentCardData card, Rect anchor) onMoreTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(
        _PaymentMethodScreenState._screenPadding,
        0,
        _PaymentMethodScreenState._screenPadding,
        24,
      ),
      physics: const ClampingScrollPhysics(),
      itemCount: cards.length,
      separatorBuilder: (_, _) =>
          const SizedBox(height: _PaymentMethodScreenState._cardGap),
      itemBuilder: (context, index) {
        final card = cards[index];
        return _PaymentCardItem(
          card: card,
          onMoreTap: (anchor) => onMoreTap(card, anchor),
        );
      },
    );
  }
}

class _PaymentCardItem extends StatelessWidget {
  const _PaymentCardItem({required this.card, required this.onMoreTap});

  final _PaymentCardData card;
  final void Function(Rect anchor) onMoreTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: 137,
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border(context), width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Center(
                child: Image.asset(
                  AppAssets.paymentCardPattern,
                  width: 125,
                  height: 64,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                  isAntiAlias: true,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const _PaymentCardBrandIcon(),
                    const Spacer(),
                    _CardMoreButton(onTap: onMoreTap),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  card.maskedNumber,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: AppTextStyles.heading4(context).copyWith(
                    color: AppColors.onSurface(context),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${l10n.expiryDate} : ',
                        style: AppTextStyles.caption(
                          context,
                        ).copyWith(color: AppColors.paragraph(context)),
                      ),
                      TextSpan(text: card.expiry),
                    ],
                  ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentCardBrandIcon extends StatelessWidget {
  const _PaymentCardBrandIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SvgPicture.asset(AppAssets.paymentCardIcon),
    );
  }
}

class _CardMoreButton extends StatelessWidget {
  const _CardMoreButton({required this.onTap});

  final void Function(Rect anchor) onTap;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (buttonContext) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            final box = buttonContext.findRenderObject() as RenderBox;
            final origin = box.localToGlobal(Offset.zero);
            onTap(origin & box.size);
          },
          child: Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surfaceCard(context),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowStrong.withValues(alpha: 0.12),
                  blurRadius: 4,
                ),
              ],
            ),
            child: SvgPicture.asset(
              AppAssets.paymentMoreIcon,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                AppColors.onSurface(context),
                BlendMode.srcIn,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CardActionsMenu extends StatelessWidget {
  const _CardActionsMenu({required this.onDelete});

  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: AppColors.transparent,
      child: Container(
        width: _PaymentMethodScreenState._actionsMenuWidth,
        height: _PaymentMethodScreenState._actionsMenuHeight,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard(context),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.08),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CardMenuAction(
              label: l10n.deleteCard,
              iconAsset: AppAssets.paymentDeleteIcon,
              onTap: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _CardMenuAction extends StatelessWidget {
  const _CardMenuAction({
    required this.label,
    required this.iconAsset,
    required this.onTap,
  });

  final String label;
  final String iconAsset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconAsset,
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(
              AppColors.onSurface(context),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 8),
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
        ],
      ),
    );
  }
}

class _DeleteCardDialog extends StatelessWidget {
  const _DeleteCardDialog({required this.onDelete});

  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      backgroundColor: AppColors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 20),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBackground(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppAssets.paymentDeleteDialogIcon,
              width: 48,
              height: 48,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.deleteCardTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.appBarTitle(context).copyWith(
                color: AppColors.onSurface(context),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.deleteCardMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.footerSecondary(context).copyWith(
                color: AppColors.paragraph(context),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _DialogButton(
                    label: l10n.cancel,
                    foreground: AppColors.text,
                    background: AppColors.primary,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _DialogButton(
                    label: l10n.confirmDelete,
                    foreground: AppColors.primary,
                    background: AppColors.transparent,
                    borderColor: AppColors.primary,
                    onTap: onDelete,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.label,
    required this.foreground,
    required this.background,
    required this.onTap,
    this.borderColor,
  });

  final String label;
  final Color foreground;
  final Color background;
  final Color? borderColor;
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
          color: background,
          borderRadius: BorderRadius.circular(10),
          border: borderColor == null
              ? null
              : Border.all(color: borderColor!, width: 0.5),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.primaryButtonLabel.copyWith(
            color: foreground,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.25,
          ),
        ),
      ),
    );
  }
}

class _CardFormSheet extends StatefulWidget {
  const _CardFormSheet({required this.isEdit, this.card});

  final bool isEdit;
  final _PaymentCardData? card;

  @override
  State<_CardFormSheet> createState() => _CardFormSheetState();
}

class _CardFormSheetState extends State<_CardFormSheet> {
  String? _errorText;
  late final TextEditingController _numberController;
  late final TextEditingController _expiryController;
  late final TextEditingController _cvvController;

  @override
  void initState() {
    super.initState();

    final card = widget.card;
    final displayCardNumber = widget.isEdit
        ? (card?.fullNumber ?? card?.maskedNumber ?? '')
        : '';

    _numberController = TextEditingController(text: displayCardNumber);
    _expiryController = TextEditingController(text: card?.expiry ?? '');
    _cvvController = TextEditingController();
  }

  @override
  void dispose() {
    _numberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  bool _passesLuhn(String cardNumber) {
    if (cardNumber.isEmpty) return false;
    int sum = 0;
    bool alternate = false;
    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int n = int.parse(cardNumber[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) n -= 9;
      }
      sum += n;
      alternate = !alternate;
    }
    return sum % 10 == 0;
  }

  bool _isValidExpiry(String expiry) {
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(expiry)) return false;
    final parts = expiry.split('/');
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);
    if (month == null || year == null) return false;
    if (month < 1 || month > 12) return false;

    final now = DateTime.now();
    final currentYear = now.year % 100;
    final currentMonth = now.month;

    if (year < currentYear) return false;
    if (year == currentYear && month < currentMonth) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomSafe = MediaQuery.of(context).padding.bottom;
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
                  padding: const EdgeInsetsDirectional.only(
                    start: 16,
                    top: 16,
                    end: 16,
                  ),
                  child: _SheetHeader(
                    title: widget.isEdit ? l10n.editCardTitle : l10n.addNewCard,
                  ),
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
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
                          _CardNumberFormatter(),
                        ],
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
                              inputFormatters: [_ExpiryDateFormatter()],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _SheetTextField(
                              label: l10n.cvv,
                              hint: 'CVV',
                              controller: _cvvController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (_errorText != null) ...[
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 16,
                    ),
                    child: Text(
                      _errorText!,
                      style: AppTextStyles.inputText(context).copyWith(
                        color: AppColors.fieldError(context),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                ] else
                  const SizedBox(height: 20),
                _SheetBottomBar(
                  label: widget.isEdit ? l10n.updateCard : l10n.addCard,
                  bottomPadding: bottomSafe + 20,
                  onTap: () {
                    final num = _numberController.text.trim();
                    final exp = _expiryController.text.trim();
                    final cvv = _cvvController.text.trim();

                    final rawNum = num.replaceAll(' ', '');

                    if (rawNum.length < 15 ||
                        rawNum.length > 19 ||
                        !_passesLuhn(rawNum)) {
                      setState(() => _errorText = 'Invalid card number');
                      return;
                    }

                    if (!_isValidExpiry(exp)) {
                      setState(() => _errorText = 'Invalid expiry date');
                      return;
                    }

                    if (cvv.length < 3 || cvv.length > 4) {
                      setState(() => _errorText = 'Invalid CVV');
                      return;
                    }

                    setState(() => _errorText = null);

                    if (!mounted) return;

                    Navigator.of(context).pop(
                      _CardFormResult(
                        cardNumber: rawNum,
                        expiry: exp,
                        cvv: cvv,
                      ),
                    );
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
    this.inputFormatters,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

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
            inputFormatters: inputFormatters,

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
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 4,
          ),
        ],
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          height: _PaymentMethodScreenState._buttonHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.primaryButtonLabel.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.25,
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentBottomBar extends StatelessWidget {
  const _PaymentBottomBar({
    required this.label,
    required this.iconAsset,
    required this.onTap,
  });

  final String label;
  final String iconAsset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(
        _PaymentMethodScreenState._screenPadding,
        _PaymentMethodScreenState._bottomBarTop,
        _PaymentMethodScreenState._screenPadding,
        bottomSafe + _PaymentMethodScreenState._bottomBarBottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 4,
          ),
        ],
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          height: _PaymentMethodScreenState._buttonHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconAsset,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  AppColors.text,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.primaryButtonLabel.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;

    if (oldValue.text.length > newValue.text.length) {
      if (oldValue.text.endsWith(' ') && !newValue.text.endsWith(' ')) {
        text = text.substring(0, text.length - 1);
      }
    }

    final newText = text.replaceAll(' ', '');
    if (newText.length > 19) return oldValue;

    final buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(newText[i]);
    }

    final formattedString = buffer.toString();

    int cursorPosition = newValue.selection.end;
    if (cursorPosition > text.length) {
      cursorPosition = text.length;
    }

    String rawBeforeCursor = text
        .substring(0, cursorPosition)
        .replaceAll(' ', '');

    int newCursorPosition = rawBeforeCursor.length;
    for (int i = 0; i < rawBeforeCursor.length; i++) {
      if (i > 0 && i % 4 == 0) {
        newCursorPosition++;
      }
    }

    return TextEditingValue(
      text: formattedString,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;
    if (newText.length > oldValue.text.length) {
      if (newText.length > 5) return oldValue;
      if (newText.length == 2 && oldValue.text.length == 1) {
        return TextEditingValue(
          text: '$newText/',
          selection: const TextSelection.collapsed(offset: 3),
        );
      }
      if (newText.length == 3 && !newText.contains('/')) {
        return TextEditingValue(
          text: '${newText.substring(0, 2)}/${newText.substring(2)}',
          selection: const TextSelection.collapsed(offset: 4),
        );
      }
    }
    return newValue;
  }
}

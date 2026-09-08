import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/app_media.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_item.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/product_detail_cubit.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/product_detail_state.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({required this.item, super.key});

  final MenuItem item;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  final Map<String, Set<String>> _selectedOptions = {};
  String _notes = '';
  bool _hasInitializedDefaults = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocBuilder<ProductDetailCubit, ProductDetailState>(
      builder: (context, state) {
        // Use the loaded product if available, otherwise fallback to the summary item passed in
        final product = state.maybeWhen(
          loaded: (p) => p,
          orElse: () => widget.item,
        );
        
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        if (!_hasInitializedDefaults && state.maybeWhen(loaded: (_) => true, orElse: () => false)) {
          for (final modifier in product.options) {
            // Fallback: If it's required OR it's a single-choice option, default to the first value
            if ((modifier.required || modifier.maxSelect == 1) && modifier.values.isNotEmpty) {
              _selectedOptions[modifier.id] = {modifier.values.first.id};
            }
          }
          _hasInitializedDefaults = true;
        }

        double calculatedBasePrice = product.price;
        double addonsTotal = 0.0;

        for (final modifier in product.options) {
          final selectedOptionIds = _selectedOptions[modifier.id] ?? <String>{};
          for (final optId in selectedOptionIds) {
            final selectedOption = modifier.values.firstWhere(
              (o) => o.id == optId,
              orElse: () => modifier.values.first,
            );
            
            if (selectedOption.id == optId) {
              if (modifier.priceType == 'absolute') {
                // Absolute options REPLACE the base price (e.g., Size variations)
                calculatedBasePrice = selectedOption.price;
              } else {
                // Addon options ADD to the total (e.g., Extra Cheese)
                addonsTotal += selectedOption.price;
              }
            }
          }
        }

        final int unitPrice = (calculatedBasePrice + addonsTotal).toInt();
        final int total = unitPrice * _quantity;

        return Scaffold(
          backgroundColor: AppColors.scaffoldBackground(context),
          bottomNavigationBar: _ProductBottomBar(
            quantity: _quantity,
            total: total,
            onIncrement: () => setState(() => _quantity++),
            onDecrement: () =>
                setState(() => _quantity = (_quantity - 1).clamp(0, 99)),
            onSubmit: () {
              // TODO: Add to cart
              context.pop();
            },
          ),
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsetsDirectional.only(bottom: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                    child: _ProductHeader(title: l10n.productDetailsTitle),
                  ),
                  const SizedBox(height: 20),
                  
                  // Product Image
                  if (product.imageUrl.isNotEmpty)
                    AppNetworkImage(
                      product.imageUrl,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.contain,
                    )
                  else
                    _HeroProductImage(imageAsset: AppAssets.productBurgerCombo),
                  
                  // Loading Indicator
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _ProductIntro(
                          product: product,
                          notes: _notes,
                          onAddNotes: _showNotesDialog,
                        ),
                        const SizedBox(height: 20),
                        
                        // Dynamic Includes (Combo Components)
                        if (product.includes.isNotEmpty) ...[
                          Text(
                            'مكونات الوجبة',
                            textAlign: TextAlign.start,
                            style: AppTextStyles.heading4(context).copyWith(
                              color: AppColors.onSurface(context),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...product.includes.map((include) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  const Icon(Icons.circle, size: 6, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${include.quantity}x ${include.name}',
                                    style: AppTextStyles.body(context).copyWith(
                                      color: AppColors.onSurface(context),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: 20),
                        ],

                        // Dynamic Options (Sizes, Modifiers, Addons)
                        if (product.options.isEmpty)
                          const SizedBox.shrink()
                        else
                          ...product.options.map((modifier) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    modifier.name,
                                    textAlign: TextAlign.start,
                                    style: AppTextStyles.heading4(context).copyWith(
                                      color: AppColors.onSurface(context),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ...modifier.values.map((val) {
                                    final isSelected = (_selectedOptions[modifier.id] ?? <String>{}).contains(val.id);
                                    
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          final current = Set<String>.from(_selectedOptions[modifier.id] ?? {});
                                          if (modifier.maxSelect <= 1) {
                                            _selectedOptions[modifier.id] = {val.id};
                                          } else {
                                            if (isSelected) {
                                              current.remove(val.id);
                                            } else if (current.length < modifier.maxSelect) {
                                              current.add(val.id);
                                            }
                                            _selectedOptions[modifier.id] = current;
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4),
                                        child: Row(
                                          children: [
                                            if (modifier.maxSelect <= 1)
                                              SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: Radio<String>(
                                                  value: val.id,
                                                  groupValue: _selectedOptions[modifier.id]?.isNotEmpty == true
                                                      ? _selectedOptions[modifier.id]!.first
                                                      : null,
                                                  onChanged: (_) {
                                                    setState(() {
                                                      _selectedOptions[modifier.id] = {val.id};
                                                    });
                                                  },
                                                  activeColor: AppColors.primary,
                                                  visualDensity: VisualDensity.compact,
                                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                ),
                                              )
                                            else
                                              SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: Checkbox(
                                                  value: isSelected,
                                                  onChanged: (_) {
                                                    setState(() {
                                                      final current = Set<String>.from(_selectedOptions[modifier.id] ?? {});
                                                      if (isSelected) {
                                                        current.remove(val.id);
                                                      } else if (current.length < modifier.maxSelect) {
                                                        current.add(val.id);
                                                      }
                                                      _selectedOptions[modifier.id] = current;
                                                    });
                                                  },
                                                  activeColor: AppColors.primary,
                                                  visualDensity: VisualDensity.compact,
                                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                ),
                                              ),
                                            const SizedBox(width: 8),
                                            Text(
                                              val.name,
                                              style: AppTextStyles.body(context).copyWith(
                                                color: AppColors.onSurface(context),
                                                fontSize: 14,
                                              ),
                                            ),
                                            const Spacer(),
                                            if (val.price > 0)
                                              Text(
                                                modifier.priceType == 'addon'
                                                    ? '(+${val.price.toInt()} ج.م)'
                                                    : '(${val.price.toInt()} ج.م)',
                                                style: AppTextStyles.textLink(context).copyWith(
                                                  color: AppColors.onSurface(context),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showNotesDialog() async {
    final notes = await showGeneralDialog<String>(
      context: context,
      barrierColor: AppColors.overlay(context),
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return ProductNotesDialog(initialNotes: _notes);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
    if (!mounted || notes == null) return;

    setState(() => _notes = notes);
  }
}

class _ProductHeader extends StatelessWidget {
  const _ProductHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => context.pop(),
          child: SizedBox(
            width: 28,
            height: 28,
            child: Center(
              child: SvgPicture.asset(
                AppAssets.productCloseIcon,
                width: 18,
                height: 18,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).brightness == Brightness.dark
                      ? AppColors.text
                      : AppColors.onSurface(context),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          title,
          textAlign: TextAlign.start,
          style: AppTextStyles.heading4(context).copyWith(
            color: AppColors.onSurface(context),
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _HeroProductImage extends StatelessWidget {
  const _HeroProductImage({required this.imageAsset});

  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            top: 10,
            child: Image.asset(
              AppAssets.productDetailsStripes,
              fit: BoxFit.contain,
            ),
          ),
          imageAsset.startsWith('http')
              ? Image.network(
                  imageAsset,
                  width: 233,
                  height: 120,
                  fit: BoxFit.contain,
                )
              : Image.asset(
                  imageAsset,
                  width: 233,
                  height: 120,
                  fit: BoxFit.contain,
                ),
        ],
      ),
    );
  }
}

class _ProductIntro extends StatelessWidget {
  const _ProductIntro({
    required this.product,
    required this.notes,
    required this.onAddNotes,
  });

  final MenuItem product;
  final String notes;
  final VoidCallback onAddNotes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasNotes = notes.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          product.name,
          textAlign: TextAlign.start,
          style: AppTextStyles.body(context).copyWith(
            color: AppColors.onSurface(context),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.description,
          textAlign: TextAlign.start,
          style: AppTextStyles.caption(context).copyWith(
            color: AppColors.paragraph(context),
            fontSize: 12,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onAddNotes,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(AppAssets.cartEditIcon, width: 14, height: 14),
                const SizedBox(width: 4),
                Text(
                  hasNotes ? l10n.productEditNotes : l10n.productAddNotes,
                  style: AppTextStyles.textLink(context).copyWith(
                    color: AppColors.onSurface(context),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (hasNotes) ...[
          const SizedBox(height: 16),
          _SavedProductNotes(notes: notes.trim()),
        ],
      ],
    );
  }

}

class _SavedProductNotes extends StatelessWidget {
  const _SavedProductNotes({required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.productYourNotes,
          textAlign: TextAlign.start,
          style: AppTextStyles.heading4(context).copyWith(
            color: AppColors.onSurface(context),
            fontSize: 15,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          notes,
          textAlign: TextAlign.start,
          style: AppTextStyles.caption(context).copyWith(
            color: AppColors.onSurface(context),
            fontSize: 12,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

class ProductNotesDialog extends StatefulWidget {
  const ProductNotesDialog({required this.initialNotes, super.key});

  final String initialNotes;

  @override
  State<ProductNotesDialog> createState() => _ProductNotesDialogState();
}

class _ProductNotesDialogState extends State<ProductNotesDialog> {
  static const _dialogHeight = 271.0;
  static const _dialogMaxWidth = 375.0;
  static const _keyboardGap = 20.0;
  static const _minimumTopMargin = 20.0;

  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNotes);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return Material(
      color: AppColors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dialogWidth = constraints.maxWidth < _dialogMaxWidth
              ? constraints.maxWidth
              : _dialogMaxWidth;
          final centeredTop = (constraints.maxHeight - _dialogHeight) / 2;
          final keyboardSafeTop =
              constraints.maxHeight -
              keyboardInset -
              _keyboardGap -
              _dialogHeight;
          final top = _resolveDialogTop(
            centeredTop: centeredTop,
            keyboardSafeTop: keyboardSafeTop,
            keyboardInset: keyboardInset,
          );

          return Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.of(context).pop();
                  },
                  child: const SizedBox.expand(),
                ),
              ),
              AnimatedPositionedDirectional(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                top: top,
                start: 0,
                end: 0,
                child: Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                    child: SizedBox(
                      width: dialogWidth,
                      height: _dialogHeight,
                      child: Material(
                        color: AppColors.scaffoldBackground(context),
                        borderRadius: BorderRadius.circular(12),
                        clipBehavior: Clip.antiAlias,
                        child: _ProductNotesDialogContent(
                          controller: _controller,
                          l10n: l10n,
                          fieldBorder: _fieldBorder,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  double _resolveDialogTop({
    required double centeredTop,
    required double keyboardSafeTop,
    required double keyboardInset,
  }) {
    if (keyboardInset <= 0) {
      return centeredTop.clamp(_minimumTopMargin, double.infinity).toDouble();
    }

    if (keyboardSafeTop < _minimumTopMargin) {
      return _minimumTopMargin;
    }

    return centeredTop.clamp(_minimumTopMargin, keyboardSafeTop).toDouble();
  }

  OutlineInputBorder _fieldBorder(BuildContext context, Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: 0.5),
    );
  }
}

class _ProductNotesDialogContent extends StatelessWidget {
  const _ProductNotesDialogContent({
    required this.controller,
    required this.l10n,
    required this.fieldBorder,
  });

  final TextEditingController controller;
  final AppLocalizations l10n;
  final OutlineInputBorder Function(BuildContext context, Color color)
  fieldBorder;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.productNotesTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.appBarTitle(context).copyWith(
                color: AppColors.onSurface(context),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Divider(
              height: 1,
              thickness: 0.5,
              color: AppColors.border(context),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.productNotesTitle,
              textAlign: TextAlign.start,
              style: AppTextStyles.body(context).copyWith(
                color: AppColors.onSurface(context),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 96,
              child: TextField(
                controller: controller,
                minLines: null,
                maxLines: null,
                expands: true,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.top,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                cursorColor: AppColors.cursor(context),
                style: AppTextStyles.inputText(
                  context,
                ).copyWith(fontSize: 12, height: 1.3),
                decoration: InputDecoration(
                  hintText: l10n.productNotesHint,
                  hintStyle: AppTextStyles.inputHint(context).copyWith(
                    color: AppColors.hint(context),
                    fontSize: 12,
                    height: 1.3,
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceCard(context),
                  contentPadding: const EdgeInsetsDirectional.fromSTEB(
                    16,
                    16,
                    16,
                    16,
                  ),
                  border: fieldBorder(context, AppColors.border(context)),
                  enabledBorder: fieldBorder(
                    context,
                    AppColors.border(context),
                  ),
                  focusedBorder: fieldBorder(
                    context,
                    AppColors.fieldFocusBorder(context),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Navigator.of(context).pop(controller.text.trim());
              },
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  l10n.productNotesSubmit,
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
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductBottomBar extends StatelessWidget {
  const _ProductBottomBar({
    required this.quantity,
    required this.total,
    required this.onIncrement,
    required this.onDecrement,
    required this.onSubmit,
  });

  final int quantity;
  final int total;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final enabled = quantity > 0;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        border: Border(
          top: BorderSide(color: AppColors.border(context), width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 20),
          child: Row(
            children: [
              _BottomQuantityControl(
                quantity: quantity,
                onIncrement: onIncrement,
                onDecrement: onDecrement,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: enabled ? onSubmit : null,
                  child: Container(
                    height: 48,
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                    decoration: BoxDecoration(
                      color: enabled
                          ? AppColors.primary
                          : AppColors.inactiveIndicator,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.productAddToCart,
                          style: AppTextStyles.buttonHeading(context).copyWith(
                            color: enabled
                                ? AppColors.text
                                : AppColors.paragraph(context),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                          ),
                        ),
                        Text(
                          l10n.cartPrice(total),
                          style: AppTextStyles.buttonHeading(context).copyWith(
                            color: enabled
                                ? AppColors.text
                                : AppColors.paragraph(context),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomQuantityControl extends StatelessWidget {
  const _BottomQuantityControl({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border(context), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onIncrement,
            child: SvgPicture.asset(
              AppAssets.cartPlusIcon,
              width: 20,
              height: 20,
            ),
          ),
          const SizedBox(width: 14),
          SizedBox(
            width: 13,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: AppTextStyles.body(context).copyWith(
                color: AppColors.onSurface(context),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.35,
              ),
            ),
          ),
          const SizedBox(width: 14),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onDecrement,
            child: SvgPicture.asset(
              quantity <= 1
                  ? AppAssets.cartDeleteIcon
                  : AppAssets.cartMinusIcon,
              width: 20,
              height: 20,
            ),
          ),
        ],
      ),
    );
  }
}



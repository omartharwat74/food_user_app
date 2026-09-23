import 'package:flutter/material.dart';

import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/app_radius.dart';
import 'package:food_user_app/core/theme/app_spacing.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/app_media.dart';

class AppSearchField extends StatefulWidget {
  const AppSearchField({
    required this.controller,
    required this.hint,
    super.key,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.isLoading = false,
    this.height = 40,
    this.iconAsset,
    this.iconGap = AppSpacing.sm,
    this.horizontalPadding = 12,
    this.showClearButton = false,
    this.loadingSize = 18,
    this.loadingStrokeWidth = 2,
    this.hintColor,
    this.textStyle,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool isLoading;
  final double height;
  final String? iconAsset;
  final double iconGap;
  final double horizontalPadding;
  final bool showClearButton;
  final double loadingSize;
  final double loadingStrokeWidth;
  final Color? hintColor;
  final TextStyle? textStyle;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  FocusNode? _internalFocusNode;
  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _effectiveFocusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(AppSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_onFocusChange);
      _internalFocusNode?.removeListener(_onFocusChange);
      _effectiveFocusNode.addListener(_onFocusChange);
    }
  }

  void _onFocusChange() {
    if (_effectiveFocusNode.hasFocus && widget.controller.text.isNotEmpty) {
      widget.controller.selection = TextSelection.collapsed(
        offset: widget.controller.text.length,
      );
    }
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_onFocusChange);
    _internalFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller.text.isNotEmpty;

    return Container(
      height: widget.height,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: widget.horizontalPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        borderRadius: const BorderRadius.all(AppRadius.sm),
        border: Border.all(color: AppColors.border(context), width: 0.5),
      ),
      child: Row(
        children: [
          _SearchIcon(iconAsset: widget.iconAsset),
          SizedBox(width: widget.iconGap),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _effectiveFocusNode,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              textAlign: TextAlign.start,
              textInputAction: TextInputAction.search,
              cursorColor: AppColors.cursor(context),
              style:
                  widget.textStyle ??
                  AppTextStyles.inputText(
                    context,
                  ).copyWith(fontSize: 12, height: 1.3),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsetsDirectional.zero,
                hintText: widget.hint,
                hintStyle: AppTextStyles.inputHint(context).copyWith(
                  color: widget.hintColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                ),
              ),
            ),
          ),
          if (widget.isLoading)
            SizedBox(
              width: widget.loadingSize,
              height: widget.loadingSize,
              child: CircularProgressIndicator(
                strokeWidth: widget.loadingStrokeWidth,
                color: AppColors.paragraph(context),
              ),
            )
          else if (widget.showClearButton && hasText && widget.onClear != null)
            IconButton(
              onPressed: widget.onClear,
              style: IconButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: const Size(36, 36),
                padding: EdgeInsets.zero,
              ),
              icon: Icon(
                Icons.close_rounded,
                size: 18,
                color: AppColors.paragraph(context),
              ),
            ),
        ],
      ),
    );
  }
}

class _SearchIcon extends StatelessWidget {
  const _SearchIcon({required this.iconAsset});

  final String? iconAsset;

  @override
  Widget build(BuildContext context) {
    if (iconAsset == null) {
      return Icon(
        Icons.search_rounded,
        color: AppColors.hint(context),
        size: 20,
      );
    }

    return AppSvgImage.asset(
      iconAsset!,
      width: 16,
      height: 16,
      color: AppColors.paragraph(context),
    );
  }
}

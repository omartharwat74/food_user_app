import 'package:flutter/material.dart';

import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/app_radius.dart';
import 'package:food_user_app/core/theme/app_spacing.dart';
import 'package:food_user_app/core/theme/text_styles.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.hint,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
  });

  final String hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);

    if (widget.controller != null && widget.controller!.text.isNotEmpty) {
      widget.controller!.selection = TextSelection.collapsed(
        offset: widget.controller!.text.length,
      );
    }
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus &&
        widget.controller != null &&
        widget.controller!.text.isNotEmpty) {
      widget.controller!.selection = TextSelection.collapsed(
        offset: widget.controller!.text.length,
      );
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  TextDirection? _getDirection(String text) {
    if (text.isEmpty) return null;
    final isEnglish = RegExp(r'^[a-zA-Z0-9]').hasMatch(text);
    return isEnglish ? TextDirection.ltr : null;
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: const BorderRadius.all(AppRadius.sm),
      borderSide: BorderSide(color: AppColors.border(context), width: 0.5),
    );

    return TextFormField(
      focusNode: _focusNode,
      controller: widget.controller,
      validator: widget.validator,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textDirection: _getDirection(widget.controller?.text ?? ''),
      onChanged: (val) {
        if (widget.onChanged != null) widget.onChanged!(val);
        setState(() {});
      },
      cursorColor: AppColors.cursor(context),
      style: AppTextStyles.inputText(context),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: AppColors.surfaceCard(context),
        hintText: widget.hint,
        hintStyle: AppTextStyles.inputHint(context),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        contentPadding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(
            color: AppColors.fieldFocusBorder(context),
            width: 1,
          ),
        ),
        errorBorder: border.copyWith(
          borderSide: BorderSide(
            color: AppColors.fieldError(context),
            width: 1,
          ),
        ),
        focusedErrorBorder: border.copyWith(
          borderSide: BorderSide(
            color: AppColors.fieldError(context),
            width: 1,
          ),
        ),
      ),
    );
  }
}

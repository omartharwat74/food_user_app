import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_user_app/features/profile/presentation/pages/verify_phone_otp_args.dart';

import 'package:go_router/go_router.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/app_radius.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/app_directional_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:food_user_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:food_user_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:food_user_app/features/user/domain/models/update_profile_request.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  bool _didSetInitialProfileData = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didSetInitialProfileData) return;
    final profile = context.read<ProfileBloc>().state.profile;
    if (profile != null) {
      _nameController.text = profile.fullName.isNotEmpty
          ? profile.fullName
          : '${profile.firstName} ${profile.lastName}';
      _emailController.text = profile.email;
      _phoneController.text = profile.phone;
    }
    _didSetInitialProfileData = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    FocusManager.instance.primaryFocus?.unfocus();
    final fullName = _nameController.text.trim();
    final parts = fullName.split(' ');
    final firstName = parts.isNotEmpty ? parts.first : '';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    context.read<ProfileBloc>().add(
      UpdateProfileEvent(
        UpdateProfileRequest(firstName: firstName, lastName: lastName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: BlocListener<ProfileBloc, ProfileState>(
        listenWhen: (prev, curr) =>
            curr.updateProfileSuccess != prev.updateProfileSuccess ||
            curr.errorMessage != prev.errorMessage ||
            curr.sendCurrentOtpSuccess != prev.sendCurrentOtpSuccess ||
            curr.profile != prev.profile,
        listener: (context, state) {
          if (state.updateProfileSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  l10n.profileUpdatedDesignOnly,
                  style: AppTextStyles.snackBarMessage(context),
                ),
              ),
            );
            context.pop();
          }
          if (state.sendCurrentOtpSuccess) {
            context.push(
              RouteNames.verifyPhoneOtp,
              extra: VerifyPhoneOtpArgs(
                phoneNumber: state.profile?.phone ?? '',
                isCurrentPhone: true,
              ),
            );
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage!,
                  style: AppTextStyles.snackBarMessage(context),
                ),
              ),
            );
          }
          final profile = state.profile;
          if (profile != null) {
            if (_nameController.text.isEmpty) {
              _nameController.text = profile.fullName.isNotEmpty
                  ? profile.fullName
                  : '${profile.firstName} ${profile.lastName}';
            }
            // phone and email are read-only, so always sync them with the latest profile state
            _emailController.text = profile.email;
            _phoneController.text = profile.phone;
          }
        },
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfileHeader(title: l10n.personalDataTitle),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      16,
                      20,
                      16,
                      24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _ProfileField(
                          label: l10n.email,
                          controller: _emailController,
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          textDirection: TextDirection.ltr,
                        ),
                        const SizedBox(height: 16),
                        _ProfileField(
                          label: l10n.fullName,
                          controller: _nameController,
                          textInputAction: TextInputAction.done,
                        ),
                        const SizedBox(height: 16),
                        _ProfileField(
                          label: l10n.mobileNumber,
                          controller: _phoneController,
                          readOnly: true,
                          keyboardType: TextInputType.phone,
                          textDirection: TextDirection.ltr,
                          trailing: _PhoneChangeAction(
                            label: l10n.changePhone,
                            onTap: () {
                              context.read<ProfileBloc>().add(
                                const SendCurrentPhoneOtpEvent(),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, state) {
                            if (state.isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return _PrimaryProfileButton(
                              label: l10n.saveChanges,
                              onTap: _saveProfile,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
        child: Row(
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
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: AppTextStyles.appBarTitle(context).copyWith(
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

class _ProfileField extends StatefulWidget {
  const _ProfileField({
    required this.label,
    required this.controller,
    this.readOnly = false,
    this.keyboardType,
    this.textDirection,
    this.textInputAction,
    this.trailing,
  });

  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final TextInputType? keyboardType;
  final TextDirection? textDirection;
  final TextInputAction? textInputAction;
  final Widget? trailing;

  @override
  State<_ProfileField> createState() => _ProfileFieldState();
}

class _ProfileFieldState extends State<_ProfileField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && widget.controller.text.isNotEmpty) {
      widget.controller.selection = TextSelection.collapsed(
        offset: widget.controller.text.length,
      );
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final fieldTextAlign = widget.textDirection == TextDirection.ltr && isRtl
        ? TextAlign.right
        : TextAlign.start;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          textAlign: TextAlign.start,
          style: AppTextStyles.fieldLabel(context).copyWith(
            color: AppColors.onSurface(context),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard(context),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border(context), width: 0.5),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  controller: widget.controller,
                  readOnly: widget.readOnly,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  textDirection: widget.textDirection,
                  textAlign: fieldTextAlign,
                  cursorColor: AppColors.cursor(context),
                  style: AppTextStyles.inputText(context).copyWith(
                    color: widget.readOnly
                        ? AppColors.paragraph(context)
                        : AppColors.onSurface(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (widget.trailing != null) ...[
                const SizedBox(width: 12),
                widget.trailing!,
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _PhoneChangeAction extends StatelessWidget {
  const _PhoneChangeAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: 32,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTextStyles.textLink(context).copyWith(
                  color: AppColors.onSurface(context),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
              const SizedBox(width: 6),
              SvgPicture.asset(
                AppAssets.profileEditIcon,
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimaryProfileButton extends StatelessWidget {
  const _PrimaryProfileButton({required this.label, required this.onTap});

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
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.all(AppRadius.sm),
        ),
        child: Text(
          label,
          style: AppTextStyles.primaryButtonLabel.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.25,
          ),
        ),
      ),
    );
  }
}

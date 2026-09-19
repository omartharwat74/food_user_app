import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/app_radius.dart';
import 'package:food_user_app/core/theme/app_spacing.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:food_user_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:food_user_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:food_user_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:food_user_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

class AccountTabPage extends StatelessWidget {
  const AccountTabPage({super.key});

  static const _horizontalPadding = AppSpacing.md;
  static const _topBarSafeGap = 20.0;
  static const _topBarToProfileGap = 16.0;
  static const _profileToMenuGap = 21.0;
  static const _profileHeaderOverlap = 37.0;
  static const _topBarHeight = 36.0;
  static const _profileHeight = 72.0;
  static const _menuRowHeight = 32.0;
  static const _menuItemHeight = 64.0;
  static const _regularMenuItemCount = 7;
  static const _menuContentHeight =
      (_menuItemHeight * _regularMenuItemCount) + _menuRowHeight;
  static const _avatarSize = 40.0;
  static const _menuIconCircleSize = 32.0;
  static const _arrowSize = 24.0;
  static const _shadowColor = AppColors.accountShadow;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final loggingOut = state is LogoutInProgress;

        return LayoutBuilder(
          builder: (context, constraints) {
            final layout = _AccountLayoutValues.fromContext(context);
            final height = math.max(
              constraints.maxHeight,
              layout.menuTop + _menuContentHeight,
            );

            return ColoredBox(
              color: AppColors.scaffoldBackground(context),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: SizedBox(
                  height: height,
                  child: Stack(
                    children: [
                      _AccountHeaderBar(
                        height: layout.headerHeight,
                        topRowTop: layout.topRowTop,
                      ),
                      _AccountProfileCard(top: layout.profileTop),
                      PositionedDirectional(
                        top: layout.menuTop,
                        start: _horizontalPadding,
                        end: _horizontalPadding,
                        child: _AccountMenu(loggingOut: loggingOut),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _AccountLayoutValues {
  const _AccountLayoutValues({
    required this.topRowTop,
    required this.profileTop,
    required this.menuTop,
    required this.headerHeight,
  });

  final double topRowTop;
  final double profileTop;
  final double menuTop;
  final double headerHeight;

  factory _AccountLayoutValues.fromContext(BuildContext context) {
    final topSafe = MediaQuery.of(context).padding.top;

    /// topRowTop = safeArea + 20
    final topRowTop = topSafe + AccountTabPage._topBarSafeGap;

    /// profileTop = topRowTop + 36 + 16
    final profileTop =
        topRowTop +
        AccountTabPage._topBarHeight +
        AccountTabPage._topBarToProfileGap;

    /// menuTop = profileTop + 72 + 21
    final menuTop =
        profileTop +
        AccountTabPage._profileHeight +
        AccountTabPage._profileToMenuGap;

    /// headerHeight = profileTop + 37
    final headerHeight = profileTop + AccountTabPage._profileHeaderOverlap;

    return _AccountLayoutValues(
      topRowTop: topRowTop,
      profileTop: profileTop,
      menuTop: menuTop,
      headerHeight: headerHeight,
    );
  }
}

class _AccountHeaderBar extends StatelessWidget {
  const _AccountHeaderBar({required this.height, required this.topRowTop});

  final double height;
  final double topRowTop;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          const Positioned.fill(
            child: ColoredBox(color: AppColors.primary),
          ),
          Positioned.fill(
            child: Image.asset(
              AppAssets.headerPattern,
              fit: BoxFit.cover,
            ),
          ),
          PositionedDirectional(
            top: topRowTop,
            start: AccountTabPage._horizontalPadding,
            end: AccountTabPage._horizontalPadding,
            child: SizedBox(
              height: AccountTabPage._topBarHeight,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  l10n.accountTitle,
                  style: AppTextStyles.heading4(context).copyWith(
                    color: AppColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountProfileCard extends StatelessWidget {
  const _AccountProfileCard({required this.top});

  final double top;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final chevronIcon = _detailsChevronIcon(context);

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final profile = state.profile;
        final name = profile != null && profile.fullName.isNotEmpty
            ? profile.fullName
            : (profile != null && profile.firstName.isNotEmpty
                  ? '${profile.firstName} ${profile.lastName}'
                  : '');
        final email = profile != null && profile.email.isNotEmpty
            ? profile.email
            : '';
        final letter = name.isNotEmpty ? name.characters.first : 'U';

        return PositionedDirectional(
          top: top,
          start: AccountTabPage._horizontalPadding,
          end: AccountTabPage._horizontalPadding,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => context.push(RouteNames.editProfile),
            child: Container(
              height: AccountTabPage._profileHeight,
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard(context),
                borderRadius: const BorderRadius.all(AppRadius.md),
                boxShadow: const [
                  BoxShadow(color: AccountTabPage._shadowColor, blurRadius: 4),
                ],
              ),
              child: Row(
                children: [
                  _Avatar(letter: letter),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: AppTextStyles.textFieldTitle(context).copyWith(
                            color: AppColors.onSurface(context),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.ltr,
                          textAlign: isRtl ? TextAlign.right : TextAlign.left,
                          style: AppTextStyles.caption(context).copyWith(
                            color: AppColors.paragraph(context),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    chevronIcon,
                    color: AppColors.onSurface(context),
                    size: AccountTabPage._arrowSize,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.letter});

  final String letter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AccountTabPage._avatarSize,
      height: AccountTabPage._avatarSize,
      decoration: const BoxDecoration(
        color: AppColors.errorTint,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: AppTextStyles.heading4(context).copyWith(
          color: AppColors.primary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
      ),
    );
  }
}

class _AccountMenu extends StatelessWidget {
  const _AccountMenu({required this.loggingOut});

  final bool loggingOut;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = [
      _AccountMenuItem(
        title: l10n.accountGeneralSettings,
        iconAsset: AppAssets.settingsGeneral,
        onTap: () => context.push(RouteNames.settings),
      ),
      _AccountMenuItem(
        title: l10n.accountFavorites,
        iconAsset: AppAssets.settingsFavorites,
        onTap: () => context.push(RouteNames.favourites),
      ),
      _AccountMenuItem(
        title: l10n.accountDiscountPoints,
        iconAsset: AppAssets.settingsDiscountPoints,
        onTap: () => context.push(RouteNames.discountPoints),
      ),
      _AccountMenuItem(
        title: l10n.accountSavedAddresses,
        iconAsset: AppAssets.settingsSavedAddresses,
        onTap: () => context.push(RouteNames.addressBook),
      ),
      _AccountMenuItem(
        title: l10n.accountCards,
        iconAsset: AppAssets.settingsCards,
        onTap: () => context.push(RouteNames.paymentMethod),
      ),
      _AccountMenuItem(
        title: l10n.accountTechnicalSupport,
        iconAsset: AppAssets.settingsSupport,
        onTap: () => context.push(RouteNames.helpSupport),
      ),
      _AccountMenuItem(
        title: l10n.accountTermsAndConditions,
        iconAsset: AppAssets.settingsTerms,
        onTap: () => context.push(RouteNames.termsAndConditions),
      ),
      _AccountMenuItem(
        title: loggingOut ? l10n.accountLoggingOut : l10n.accountLogout,
        iconAsset: AppAssets.settingsLogout,
        enabled: !loggingOut,
        showArrow: false,
        onTap: () => context.read<AuthBloc>().add(const LogoutRequested()),
      ),
    ];

    return Column(
      children: List.generate(items.length, (index) {
        final isLogout = index == items.length - 1;
        return SizedBox(
          height: isLogout
              ? AccountTabPage._menuRowHeight
              : AccountTabPage._menuItemHeight,
          child: Column(
            children: [
              items[index],
              if (!isLogout)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Divider(
                    height: 1,
                    thickness: 0.5,
                    color: AppColors.border(context),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _AccountMenuItem extends StatelessWidget {
  const _AccountMenuItem({
    required this.title,
    required this.iconAsset,
    required this.onTap,
    this.enabled = true,
    this.showArrow = true,
  });

  final String title;
  final String iconAsset;
  final VoidCallback onTap;
  final bool enabled;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    final chevronIcon = _detailsChevronIcon(context);
    final textColor = enabled
        ? AppColors.onSurface(context)
        : AppColors.paragraph(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? onTap : null,
      child: SizedBox(
        height: AccountTabPage._menuRowHeight,
        child: Row(
          children: [
            SvgPicture.asset(
              iconAsset,
              width: AccountTabPage._menuIconCircleSize,
              height: AccountTabPage._menuIconCircleSize,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: AppTextStyles.body(context).copyWith(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.25,
                ),
              ),
            ),
            if (showArrow) ...[
              const SizedBox(width: AppSpacing.sm),
              Icon(
                chevronIcon,
                color: textColor,
                size: AccountTabPage._arrowSize,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

IconData _detailsChevronIcon(BuildContext context) {
  final isRtl = Directionality.of(context) == TextDirection.rtl;
  return isRtl ? Icons.chevron_right_rounded : Icons.chevron_right_rounded;
}

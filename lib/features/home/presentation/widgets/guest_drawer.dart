import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/localization/app_locale_scope.dart';
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/app_theme_scope.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/app_media.dart';
import 'package:food_user_app/features/auth/presentation/widgets/app_language_picker_modal.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

/// Guest navigation drawer displayed in [HomeScreen] for guest users.
/// Matches the exact styling and behavior of the General Settings screen.
class GuestDrawer extends StatelessWidget {
  const GuestDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = AppLocaleScope.of(context).locale;
    final themeController = AppThemeScope.of(context);
    final themeMode = themeController.themeMode;
    final isDark = switch (themeMode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system => Theme.of(context).brightness == Brightness.dark,
    };

    return Drawer(
      backgroundColor: AppColors.scaffoldBackground(context),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Drawer Header ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 16),
              child: Row(
                children: [
                  const AppRasterImage.asset(
                    AppAssets.onboardingLogo,
                    width: 34,
                    height: 34,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.settingsTitle,
                      style: AppTextStyles.heading4(context).copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 0.5,
              color: AppColors.border(context),
            ),
            const SizedBox(height: 12),

            // ── Settings List ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // 1. Language Option
                  _DrawerSettingsRow(
                    iconAsset: AppAssets.generalSettingsLanguage,
                    title: l10n.changeAppLanguage,
                    trailing: _LanguageTrailing(
                      label: locale.languageCode == 'ar'
                          ? l10n.arabicLanguage
                          : l10n.englishLanguage,
                    ),
                    onTap: () => showAppLanguagePicker(context),
                  ),
                  const _DrawerDivider(),

                  // 2. Dark Mode Option
                  _DrawerSettingsRow(
                    iconAsset: AppAssets.generalSettingsDarkMode,
                    title: l10n.darkMode,
                    trailing: _DarkModeSwitch(
                      value: isDark,
                      onChanged: (value) {
                        themeController.setThemeMode(
                          value ? ThemeMode.dark : ThemeMode.light,
                        );
                      },
                    ),
                  ),
                  const _DrawerDivider(),

                  const SizedBox(height: 24),

                  // 3. Login / Create Account Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.go(RouteNames.authEntry);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.account_circle_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.guestLoginPrompt,
                            style: AppTextStyles.buttonHeading(context).copyWith(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerSettingsRow extends StatelessWidget {
  const _DrawerSettingsRow({
    required this.iconAsset,
    required this.title,
    this.trailing,
    this.onTap,
  });

  final String iconAsset;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            AppSvgImage.asset(iconAsset, width: 32, height: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
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
            ),
            if (trailing != null) ...[const SizedBox(width: 8), trailing!],
          ],
        ),
      ),
    );
  }
}

class _DrawerDivider extends StatelessWidget {
  const _DrawerDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, thickness: 0.5, color: AppColors.border(context));
  }
}

class _LanguageTrailing extends StatelessWidget {
  const _LanguageTrailing({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.body(context).copyWith(
            color: AppColors.paragraph(context),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.25,
          ),
        ),
        const SizedBox(width: 4),
        Icon(
          Icons.chevron_right_rounded,
          size: 20,
          color: AppColors.paragraph(context),
        ),
      ],
    );
  }
}

class _DarkModeSwitch extends StatelessWidget {
  const _DarkModeSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: Semantics(
        toggled: value,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: 56,
          height: 28,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: AppColors.text,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: AppColors.settingsSwitchBorder,
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.08),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            alignment: value ? Alignment.centerLeft : Alignment.centerRight,
            child: _DarkModeSwitchKnob(value: value),
          ),
        ),
      ),
    );
  }
}

class _DarkModeSwitchKnob extends StatelessWidget {
  const _DarkModeSwitchKnob({required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: value ? AppColors.darkModeKnobOn : AppColors.darkModeKnobOff,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        value ? Icons.nightlight_round : Icons.wb_sunny_rounded,
        size: 16,
        color: value ? AppColors.text : AppColors.sunIcon,
      ),
    );
  }
}

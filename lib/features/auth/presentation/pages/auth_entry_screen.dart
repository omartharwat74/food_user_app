import 'complete_profile_args.dart';
import 'phone_auth_screen.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/app_media.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:food_user_app/core/utils/error_localizer.dart';
import 'package:food_user_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:food_user_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:food_user_app/features/auth/presentation/bloc/auth_state.dart';

class AuthEntryScreen extends StatelessWidget {
  const AuthEntryScreen({super.key});

  void _startPhoneFlow(BuildContext context) {
    context.push(RouteNames.phoneAuth, extra: const PhoneAuthArgs());
  }

  void _startSocialFlow(BuildContext context, String provider) {
    context.read<AuthBloc>().add(SocialLoginRequested(provider: provider));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (prev, curr) => 
            curr is PhoneOtpCompleteProfile || 
            curr is PhoneOtpVerificationRequired ||
            curr is SocialLoginFailure || 
            curr is Authenticated,
        listener: (context, state) {
          if (state is PhoneOtpCompleteProfile) {
            context.push(
              RouteNames.completeProfile,
              extra: CompleteProfileArgs(
                registrationToken: state.registrationToken,
                requiredFields: state.requiredFields,
              ),
            );
          } else if (state is PhoneOtpVerificationRequired) {
            context.push(
              RouteNames.mockOtp,
              extra: MockOtpArgs(
                phoneNumber: state.phone,
                isSocial: true,
                registrationToken: state.registrationToken,
              ),
            );
          } else if (state is Authenticated) {
            context.go(RouteNames.home);
          } else if (state is SocialLoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(localizedErrorMessage(AppLocalizations.of(context)!, state.message))),
            );
          }
        },
        child: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsetsDirectional.only(
                bottom: MediaQuery.paddingOf(context).bottom + 28,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _AuthEntryHero(l10n: l10n),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        16,
                        32,
                        16,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Center(
                            child: AppRasterImage.asset(
                              AppAssets.onboardingLogo,
                              width: 53,
                              height: 52,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _AuthEntryTitle(l10n: l10n),
                          const SizedBox(height: 24),
                          _AuthMethodButton(
                            label: l10n.authContinueWithPhone,
                            onPressed: () => _startPhoneFlow(context),
                            icon: const AppRasterImage.asset(
                              AppAssets.authPhoneIcon,
                              width: 20,
                              height: 20,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _AuthMethodButton(
                            label: l10n.authContinueWithApple,
                            onPressed: () => _startSocialFlow(context, 'apple'),
                            icon: AppSvgImage.asset(
                              Theme.of(context).brightness == Brightness.dark
                                  ? AppAssets.socialAppleDark
                                  : AppAssets.socialApple,
                              width: 20,
                              height: 20,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _AuthMethodButton(
                            label: l10n.authContinueWithGoogle,
                            onPressed: () => _startSocialFlow(context, 'google'),
                            icon: const AppSvgImage.asset(
                              AppAssets.socialGoogle,
                              width: 20,
                              height: 20,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _AuthMethodButton(
                            label: l10n.authContinueWithFacebook,
                            onPressed: () => _startSocialFlow(context, 'facebook'),
                            icon: const Icon(
                              Icons.facebook_rounded,
                              size: 20,
                              color: AppColors.facebookBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ),
    );
  }
}

class _AuthEntryHero extends StatelessWidget {
  const _AuthEntryHero({required this.l10n});

  final AppLocalizations l10n;

  static const _artworkHeight = 355.0;
  static const _stripeHeight = 20.0;
  static const _stripeGap = 6.0;
  static const _stripesTotalHeight = (_stripeHeight * 3) + (_stripeGap * 2);

  static const _heroTotalHeight = _artworkHeight + _stripesTotalHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _heroTotalHeight,
      width: double.infinity,
      child: Stack(
        children: [
          // 1. الخلفية الحمراء
          PositionedDirectional(
            top: 0,
            start: 0,
            end: 0,
            height: _heroTotalHeight - 10,
            child: const ColoredBox(color: AppColors.primary),
          ),
          
          // 2. الأفاتار (مفصول عن الشرايط ومتسنتر في مساحة الخلفية الحمراء بالظبط)
          PositionedDirectional(
            top: 0,
            start: 0,
            end: 0,
            height: _heroTotalHeight - 10,
            child: Center(
              child: AppRasterImage.asset(
                AppAssets.onboardingAvatar,
                width: 113.35,
                height: 169.7,
                fit: BoxFit.contain,
              ),
            ),
            
          ),

          // 3. الشرايط اللي تحت (مرمية في آخر الـ Stack من تحت)
          const PositionedDirectional(
            bottom: 0,
            start: 0,
            end: 0,
            child: _AuthEntryStripes(),
          ),
        ],
      ),
    );
  }
}

class _AuthEntryStripes extends StatelessWidget {
  const _AuthEntryStripes();

  static const _stripeHeight = 20.0;
  static const _stripeGap = 6.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stripeAsset = isDark
        ? AppAssets.authEntryStripeDark
        : AppAssets.authEntryStripe;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppRasterImage.asset(
          stripeAsset,
          height: _stripeHeight,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
        const ColoredBox(
          color: AppColors.primary,
          child: SizedBox(height: _stripeGap, width: double.infinity),
        ),
        AppRasterImage.asset(
          stripeAsset,
          height: _stripeHeight,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
        const ColoredBox(
          color: AppColors.primary,
          child: SizedBox(height: _stripeGap, width: double.infinity),
        ),
        AppRasterImage.asset(
          stripeAsset,
          height: _stripeHeight,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
      ],
    );
  }
}

class _AuthEntryTitle extends StatelessWidget {
  const _AuthEntryTitle({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            style: AppTextStyles.heading4(
              context,
            ).copyWith(fontSize: 18, height: 1.4),
            children: [
              TextSpan(
                text: l10n.authEntryTitleAccent,
                style: AppTextStyles.heading4(
                  context,
                ).copyWith(color: AppColors.primary, fontSize: 18, height: 1.4),
              ),
              TextSpan(text: l10n.authEntryTitleRest),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.authEntrySubtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.subtitle(context),
        ),
      ],
    );
  }
}

class _AuthMethodButton extends StatelessWidget {
  const _AuthMethodButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.onSurface(context),
          side: BorderSide(color: AppColors.border(context), width: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.textLink(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhoneAuthArgs {
  const PhoneAuthArgs({
    this.startedFromSocial = false,
    this.mockNewUser = true,
    this.firstName,
    this.lastName,
    this.email,
  });

  final bool startedFromSocial;
  final bool mockNewUser;
  final String? firstName;
  final String? lastName;
  final String? email;
}

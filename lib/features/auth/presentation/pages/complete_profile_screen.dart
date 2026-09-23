import 'package:food_user_app/features/auth/presentation/widgets/phone_number_field.dart';

import 'phone_auth_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/utils/phone_formatter.dart';

import 'package:go_router/go_router.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/localization/context_locale_ext.dart';
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/app_media.dart';
import 'package:food_user_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:food_user_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:food_user_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:food_user_app/features/auth/presentation/widgets/app_language_picker_modal.dart';
import 'package:food_user_app/features/profile/presentation/controllers/saved_addresses_scope.dart';
import 'package:food_user_app/features/auth/presentation/widgets/auth_language_chip.dart';
import 'package:food_user_app/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:food_user_app/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:food_user_app/features/auth/presentation/utils/auth_error_localizer.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:food_user_app/core/widgets/app_directional_icons.dart';

class CompleteProfileScreen extends StatefulWidget {
  /// Registration token received from verify-otp `complete_profile` response.
  /// Required to call `POST /api/v1/auth/complete-profile`.
  const CompleteProfileScreen({
    super.key,
    required this.registrationToken,
    required this.requiredFields,
  });

  final String registrationToken;
  final List<String> requiredFields;

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusManager.instance.primaryFocus?.unfocus();
    
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim().formatAsEgyptianPhone();

    if (widget.requiredFields.contains('first_name') && firstName.isEmpty) return;
    if (widget.requiredFields.contains('last_name') && lastName.isEmpty) return;
    if (widget.requiredFields.contains('email') && email.isEmpty) return;
    if (widget.requiredFields.contains('phone') && phone.isEmpty) return;

    context.read<AuthBloc>().add(
      CompleteRegistrationSubmitted(
        registrationToken: widget.registrationToken,
        firstName: widget.requiredFields.contains('first_name') ? firstName : null,
        lastName: widget.requiredFields.contains('last_name') ? lastName : null,
        email: widget.requiredFields.contains('email') ? email : null,
        phone: widget.requiredFields.contains('phone') ? phone : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listenWhen: (prev, curr) =>
              curr is CompleteRegistrationSuccess ||
              curr is CompleteRegistrationFailure ||
              curr is PhoneOtpVerificationRequired,
          listener: (context, state) {
            if (state is CompleteRegistrationSuccess) {
              final addressController = SavedAddressesScope.of(context);
              addressController.loadAddressesIfNeeded().then((_) {
                if (!context.mounted) return;
                if (addressController.addresses.isEmpty) {
                  context.go('${RouteNames.addressBookAddMap}?isOnboarding=true');
                } else {
                  context.go(RouteNames.home);
                }
              });
            } else if (state is PhoneOtpVerificationRequired) {
              context.push(
                RouteNames.mockOtp,
                extra: MockOtpArgs(
                  phoneNumber: state.phone,
                  isSocial: true,
                  registrationToken: state.registrationToken,
                ),
              );
            } else if (state is CompleteRegistrationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    localizedAuthError(
                      AppLocalizations.of(context)!,
                      state.message,
                    ),
                    style: AppTextStyles.snackBarMessage(context),
                  ),
                ),
              );
            }
          },
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ProfileTopBar(onBack: () => context.pop()),
                  const SizedBox(height: 32),
                  Text(
                    l10n.completeProfileTitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.screenTitle(context),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.completeProfileSubtitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.subtitle(context),
                  ),
                  const SizedBox(height: 32),
                  if (widget.requiredFields.contains('first_name')) ...[
                    AuthTextField(
                      controller: _firstNameController,
                      label: l10n.firstNameLabel,
                      hintText: l10n.firstNameHint,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (widget.requiredFields.contains('last_name')) ...[
                    AuthTextField(
                      controller: _lastNameController,
                      label: l10n.lastNameLabel,
                      hintText: l10n.lastNameHint,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (widget.requiredFields.contains('email')) ...[
                    AuthTextField(
                      controller: _emailController,
                      label: l10n.registerEmailLabel,
                      hintText: l10n.registerEmailHint,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (widget.requiredFields.contains('phone')) ...[
                    Text(
                      l10n.registerPhoneLabel,
                      textAlign: TextAlign.start,
                      style: AppTextStyles.fieldLabel(context),
                    ),
                    const SizedBox(height: 8),
                    PhoneNumberField(
                      controller: _phoneController,
                      hintText: l10n.registerPhoneHint,
                    ),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 8),
                  BlocBuilder<AuthBloc, AuthState>(
                    buildWhen: (prev, curr) =>
                        curr is CompleteRegistrationInProgress ||
                        curr is CompleteRegistrationSuccess ||
                        curr is CompleteRegistrationFailure ||
                        curr is AuthStateInitial,
                    builder: (context, state) {
                      final isLoading = state is CompleteRegistrationInProgress;
                      return AuthPrimaryButton(
                        label: l10n.completeProfileSubmit,
                        onPressed: isLoading ? null : _submit,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Text.rich(
                    TextSpan(
                      style: AppTextStyles.termsMuted(context),
                      children: [
                        TextSpan(text: l10n.completeProfileTermsPrefix),
                        TextSpan(
                          text: l10n.registerTermsLink,
                          style: AppTextStyles.termsMuted(
                            context,
                          ).copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileTopBar extends StatelessWidget {
  const _ProfileTopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      height: 36,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: AuthLanguageChip(
              label: context.isArabic
                  ? l10n.arabicLanguage
                  : l10n.englishLanguage,
              flagAsset: context.isArabic
                  ? AppAssets.flagEg
                  : AppAssets.flagUsa,
              onTap: () => showAppLanguagePicker(context),
            ),
          ),
          Center(
            child: AppRasterImage.asset(
              AppAssets.appLogoSmall,
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: IconButton(
              onPressed: onBack,
              padding: EdgeInsets.zero,
              icon: Icon(
                AppDirectionalIcons.backChevron(context),
                size: 28,
                color: AppColors.onSurface(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:food_user_app/features/auth/presentation/pages/complete_profile_args.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:food_user_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:food_user_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:food_user_app/features/profile/presentation/controllers/saved_addresses_scope.dart';
import 'package:food_user_app/features/auth/presentation/pages/phone_auth_screen.dart';
import 'package:food_user_app/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:food_user_app/features/auth/presentation/utils/auth_error_localizer.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:food_user_app/core/widgets/app_directional_icons.dart';

class MockOtpScreen extends StatefulWidget {
  const MockOtpScreen({super.key, required this.args});

  final MockOtpArgs args;

  @override
  State<MockOtpScreen> createState() => _MockOtpScreenState();
}

class _MockOtpScreenState extends State<MockOtpScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _timer;
  int _seconds = 59;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_seconds <= 0) {
        timer.cancel();
        return;
      }
      setState(() => _seconds--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _verify() {
    FocusManager.instance.primaryFocus?.unfocus();
    final otp = _controller.text.trim();
    if (otp.length < 6) return;
    // Verify with backend; navigation happens in the BlocListener.
    context.read<AuthBloc>().add(
      PhoneOtpVerifySubmitted(
        phone: widget.args.phoneNumber,
        otp: otp,
        registrationToken: widget.args.registrationToken,
      ),
    );
  }

  void _resend() {
    if (_seconds > 0) return;
    _controller.clear();
    setState(() => _seconds = 59);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_seconds <= 0) {
        timer.cancel();
        return;
      }
      setState(() => _seconds--);
    });
    context.read<AuthBloc>().add(
      PhoneOtpRequested(phone: widget.args.phoneNumber),
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
              curr is PhoneOtpCompleteProfile ||
              curr is PhoneOtpLoginSuccess ||
              curr is CompleteRegistrationSuccess ||
              curr is CompleteRegistrationFailure ||
              curr is PhoneOtpVerifyFailure,
          listener: (context, state) {
            if (state is PhoneOtpCompleteProfile) {
              if (widget.args.isSocial &&
                  widget.args.firstName != null &&
                  widget.args.lastName != null) {
                context.read<AuthBloc>().add(
                  CompleteRegistrationSubmitted(
                    registrationToken: state.registrationToken,
                    firstName: widget.args.firstName!,
                    lastName: widget.args.lastName!,
                    email: widget.args.email,
                  ),
                );
              } else {
                context.push(
                  RouteNames.completeProfile,
                  extra: CompleteProfileArgs(
                    registrationToken: state.registrationToken,
                    requiredFields: state.requiredFields,
                  ),
                );
              }
            } else if (state is PhoneOtpLoginSuccess ||
                state is CompleteRegistrationSuccess) {
              final addressController = SavedAddressesScope.of(context);
              addressController.loadAddressesIfNeeded().then((_) {
                if (!context.mounted) return;
                if (addressController.addresses.isEmpty) {
                  context.go(
                    '${RouteNames.addressBookAddMap}?isOnboarding=true',
                  );
                } else {
                  context.go(RouteNames.home);
                }
              });
            } else if (state is PhoneOtpVerifyFailure) {
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
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: IconButton(
                      onPressed: () => context.pop(),
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        AppDirectionalIcons.backChevron(context),
                        size: 28,
                        color: AppColors.onSurface(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    l10n.otpTitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.screenTitle(context),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.authOtpSubtitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.subtitle(context),
                  ),
                  const SizedBox(height: 32),
                  _OtpBoxes(controller: _controller, focusNode: _focusNode),
                  const SizedBox(height: 20),
                  BlocBuilder<AuthBloc, AuthState>(
                    buildWhen: (prev, curr) =>
                        curr is PhoneOtpVerifyInProgress ||
                        curr is PhoneOtpCompleteProfile ||
                        curr is PhoneOtpLoginSuccess ||
                        curr is PhoneOtpVerifyFailure ||
                        curr is AuthStateInitial,
                    builder: (context, state) {
                      final isLoading = state is PhoneOtpVerifyInProgress;
                      return AuthPrimaryButton(
                        label: l10n.otpVerify,
                        onPressed: isLoading ? null : _verify,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  _ResendRow(seconds: _seconds, onResend: _resend),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OtpBoxes extends StatelessWidget {
  const _OtpBoxes({required this.controller, required this.focusNode});

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Stack(
        children: [
          Positioned.fill(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                showCursor: false,
                style: AppTextStyles.hiddenOtpInput,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              final value = controller.text;
              return Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    final active = index == value.length.clamp(0, 5);
                    final char = index < value.length ? value[index] : '-';
                    return InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: focusNode.requestFocus,
                      child: Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard(context),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: active
                                ? AppColors.otpActiveBorder(context)
                                : AppColors.border(context),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          char,
                          style: active
                              ? AppTextStyles.otpDigitActive(context)
                              : AppTextStyles.otpDigitInactive(context),
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ResendRow extends StatelessWidget {
  const _ResendRow({required this.seconds, required this.onResend});

  final int seconds;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.otpTimerSeconds(seconds),
          style: AppTextStyles.timerText(context),
        ),
        const SizedBox(width: 4),
        TextButton(
          onPressed: seconds == 0 ? onResend : null,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            l10n.otpResend,
            style: AppTextStyles.textLink(context).copyWith(
              color: seconds == 0 ? AppColors.primary : Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

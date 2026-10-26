import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/app_radius.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

/// Shows a bottom-sheet prompting the guest user to log in before proceeding.
/// Returns [true] if the user taps "Login Now", [false] if cancelled.
Future<bool> showGuestGate(BuildContext context) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const _GuestGateSheet(),
  );
  return result ?? false;
}

class _GuestGateSheet extends StatelessWidget {
  const _GuestGateSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsetsDirectional.fromSTEB(24, 20, 24, 24 + bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border(context),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.primary,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            l10n.guestGateTitle,
            style: AppTextStyles.heading4(context).copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Message
          Text(
            l10n.guestGateMessage,
            style: AppTextStyles.body(context).copyWith(
              color: AppColors.paragraph(context),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),

          // Login Now button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                context.go(RouteNames.authEntry);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(AppRadius.md),
                ),
              ),
              child: Text(
                l10n.guestGateLoginButton,
                style: AppTextStyles.buttonHeading(context).copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Cancel button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.onSurface(context),
                side: BorderSide(color: AppColors.border(context), width: 0.5),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(AppRadius.md),
                ),
              ),
              child: Text(
                l10n.cancel,
                style: AppTextStyles.buttonHeading(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

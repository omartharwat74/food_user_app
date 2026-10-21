import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/app_radius.dart';
import 'package:food_user_app/core/theme/app_spacing.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/app_directional_icons.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  static const _screenPadding = AppSpacing.md;
  static const _topInset = 20.0;
  static const _headerIconSize = 28.0;
  static const _headerGap = 8.0;
  static const _headerHeight = 28.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final currencySymbol = isArabic ? 'ر.س' : 'SAR';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: _screenPadding,
            top: _topInset,
            end: _screenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _WalletHeader(title: l10n.accountWallet),
              const SizedBox(height: 24),
              _WalletBalanceCard(
                currencySymbol: currencySymbol,
                isArabic: isArabic,
              ),
              const SizedBox(height: 28),
              Text(
                isArabic ? 'سجل العمليات' : 'Transaction History',
                style: AppTextStyles.heading4(context).copyWith(
                  color: AppColors.onSurface(context),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _EmptyWalletTransactionsState(isArabic: isArabic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WalletHeader extends StatelessWidget {
  const _WalletHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final backIcon = AppDirectionalIcons.backChevron(context);

    return SizedBox(
      height: WalletScreen._headerHeight,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.pop(),
              child: SizedBox(
                width: WalletScreen._headerIconSize,
                height: WalletScreen._headerIconSize,
                child: Icon(
                  backIcon,
                  size: WalletScreen._headerIconSize,
                  color: AppColors.onSurface(context),
                ),
              ),
            ),
            const SizedBox(width: WalletScreen._headerGap),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: AppTextStyles.appBarTitle(context).copyWith(
                color: AppColors.onSurface(context),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletBalanceCard extends StatelessWidget {
  const _WalletBalanceCard({
    required this.currencySymbol,
    required this.isArabic,
  });

  final String currencySymbol;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        borderRadius: const BorderRadius.all(AppRadius.lg),
        boxShadow: const [
          BoxShadow(
            color: AppColors.accountShadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isArabic ? 'الرصيد الحالي' : 'Current Balance',
                style: AppTextStyles.caption(context).copyWith(
                  color: AppColors.paragraph(context),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SvgPicture.asset(
                AppAssets.settingsWallet,
                width: 36,
                height: 36,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '0.00',
                style: AppTextStyles.heading1(context).copyWith(
                  color: AppColors.onSurface(context),
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                currencySymbol,
                style: AppTextStyles.heading4(context).copyWith(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyWalletTransactionsState extends StatelessWidget {
  const _EmptyWalletTransactionsState({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(16),
              child: SvgPicture.asset(
                AppAssets.settingsWallet,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isArabic ? 'لا توجد حركات سابقة' : 'No previous transactions',
              style: AppTextStyles.heading4(context).copyWith(
                color: AppColors.onSurface(context),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isArabic
                  ? 'ستظهر هنا جميع عمليات الشحن والاسترداد الخاصة بمحفظتك.'
                  : 'All wallet top-up and refund transactions will appear here.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body(context).copyWith(
                color: AppColors.paragraph(context),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

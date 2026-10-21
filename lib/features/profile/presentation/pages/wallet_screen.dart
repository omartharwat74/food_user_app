import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/di/injection_container.dart' as di;
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/app_directional_icons.dart';
import 'package:food_user_app/features/wallet/domain/entities/wallet_data.dart';
import 'package:food_user_app/features/wallet/presentation/cubit/wallet_cubit.dart';
import 'package:food_user_app/features/wallet/presentation/cubit/wallet_state.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<WalletCubit>()..loadWallet(),
      child: const _WalletView(),
    );
  }
}

class _WalletView extends StatefulWidget {
  const _WalletView();

  @override
  State<_WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<_WalletView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200) {
      final state = context.read<WalletCubit>().state;
      if (state.walletData.items.isNotEmpty) {
        context.read<WalletCubit>().loadMoreTransactions();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 16.0,
            top: 20.0,
            end: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _WalletHeader(title: l10n.accountWallet),
              const SizedBox(height: 20.0),
              Expanded(
                child: BlocBuilder<WalletCubit, WalletState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF009663),
                        ),
                      );
                    }

                    if (state.isError) {
                      return _WalletErrorState(
                        message: state.errorMessage ??
                            (isArabic
                                ? 'حدث خطأ أثناء تحميل بيانات المحفظة'
                                : 'Failed to load wallet data'),
                        onRetry: () => context.read<WalletCubit>().loadWallet(),
                      );
                    }

                    final walletData = state.walletData;
                    final items = walletData.items;

                    return RefreshIndicator(
                      color: const Color(0xFF009663),
                      onRefresh: () =>
                          context.read<WalletCubit>().refreshWallet(),
                      child: CustomScrollView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: _BalanceCard(
                                balance: walletData.balance,
                                currency: walletData.currency,
                                isArabic: isArabic,
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                isArabic
                                    ? 'المعاملات السابقة'
                                    : 'Previous Transactions',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: 'ExpoArabic',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurface(context),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                          if (items.isEmpty)
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: _EmptyTransactionsState(isArabic: isArabic),
                            )
                          else
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  if (index >= items.length) {
                                    return const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      child: Center(
                                        child: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Color(0xFF009663),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _TransactionCard(
                                      item: items[index],
                                      isArabic: isArabic,
                                    ),
                                  );
                                },
                                childCount: items.length +
                                    (state.isLoadingMore ? 1 : 0),
                              ),
                            ),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 32),
                          ),
                        ],
                      ),
                    );
                  },
                ),
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

  static const _headerIconSize = 28.0;
  static const _headerGap = 4.0;
  static const _headerHeight = 28.0;

  @override
  Widget build(BuildContext context) {
    final backIcon = AppDirectionalIcons.backChevron(context);

    return SizedBox(
      height: _headerHeight,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.pop(),
              child: SizedBox(
                width: _headerIconSize,
                height: _headerIconSize,
                child: Icon(
                  backIcon,
                  size: _headerIconSize,
                  color: AppColors.onSurface(context),
                ),
              ),
            ),
            const SizedBox(width: _headerGap),
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

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.balance,
    required this.currency,
    required this.isArabic,
  });

  final String balance;
  final String currency;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final currencyText = isArabic ? 'ج.م' : currency;
    final formattedBalance = balance.replaceAll('.', ',');

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        width: double.infinity,
        height: 110,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment(1.0, -0.07),
            end: Alignment(-1.0, 0.07),
            colors: [
              Color(0xFF0C9D61),
              Color(0xFF007746),
            ],
            stops: [0.0014, 0.9986],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(44, 43, 43, 0.08),
              blurRadius: 4,
              offset: Offset.zero,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 1. Sparkles decoration (3 Figma star ornaments)
              Positioned.fill(
                child: _BalanceCardSparkles(isArabic: isArabic),
              ),

              // 2. Curved rope in horizontal center with top: -6 (flipped horizontally in English)
              Positioned(
                top: -6,
                left: 0,
                right: 0,
                child: Center(
                  child: Transform.flip(
                    flipX: !isArabic,
                    child: SvgPicture.asset(
                      AppAssets.walletBalanceRope,
                      width: 102,
                      height: 46,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // 3. Balance text content, exactly centered vertically in the card
              Positioned.fill(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic ? 'رصيدك الحالي' : 'Current Balance',
                          style: TextStyle(
                            fontFamily: 'ExpoArabic',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              formattedBalance,
                              style: const TextStyle(
                                fontFamily: 'ExpoArabic',
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                height: 1.1,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              currencyText,
                              style: const TextStyle(
                                fontFamily: 'ExpoArabic',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 1.1,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BalanceCardSparkles extends StatelessWidget {
  const _BalanceCardSparkles({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Star 1: 29x29, distance 6.0 from the card's edge
        PositionedDirectional(
          end: 6.0,
          top: 32.0,
          child: Transform.flip(
            flipX: !isArabic,
            child: SvgPicture.asset(
              AppAssets.walletStar1,
              width: 29,
              height: 29,
              fit: BoxFit.contain,
            ),
          ),
        ),
        // Star 2: 16x16, horizontal gap reduced by 30% (~3.1px gap)
        PositionedDirectional(
          end: 37.5,
          top: 57.0,
          child: Transform.flip(
            flipX: !isArabic,
            child: SvgPicture.asset(
              AppAssets.walletStar2,
              width: 16,
              height: 16,
              fit: BoxFit.contain,
            ),
          ),
        ),
        // Star 3: 9x9, identical horizontal gap reduced by 30% (~3.1px gap)
        PositionedDirectional(
          end: 56.0,
          top: 72.5,
          child: Transform.flip(
            flipX: !isArabic,
            child: SvgPicture.asset(
              AppAssets.walletStar3,
              width: 9,
              height: 9,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({
    required this.item,
    required this.isArabic,
  });

  final WalletTransaction item;
  final bool isArabic;

  String _formatDate(String raw) {
    if (raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw);
      return '${dt.year}/${dt.month}/${dt.day}';
    } catch (_) {
      return raw.replaceAll('-', '/');
    }
  }

  String _formatAmount(double amount) {
    if (amount == amount.roundToDouble()) {
      return amount.toInt().toString();
    }
    return amount.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCredit = item.isCredit;
    final amountColor =
        isCredit ? const Color(0xFF17B07F) : const Color(0xFFF34E48);

    final statusLabel = isCredit
        ? (isArabic ? 'تم إستلام :' : 'Received :')
        : (isArabic ? 'تم دفع :' : 'Paid :');

    final displayCode = item.note.isNotEmpty ? item.note : item.id;
    final formattedDate = _formatDate(item.createdAt);
    final formattedAmount = _formatAmount(item.amount);
    final transactionIconAsset = isCredit
        ? AppAssets.walletTransactionCredit
        : AppAssets.walletTransactionDebit;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border(context), width: 1),
        boxShadow: isDark
            ? const []
            : const [
                BoxShadow(
                  color: Color(0x06000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // In RTL: Start is on the RIGHT (Icon + Order Code, with Date below)
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        transactionIconAsset,
                        width: 28,
                        height: 28,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          displayCode,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: AppColors.onSurface(context),
                            fontSize: 12,
                            fontFamily: 'ExpoArabic',
                            fontWeight: FontWeight.w400,
                            height: 1.30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isArabic
                        ? 'تاريخ العملية : $formattedDate'
                        : 'Date : $formattedDate',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'ExpoArabic',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.paragraph(context),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // In RTL: End is on the LEFT, vertically centered in the card
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  statusLabel,
                  style: TextStyle(
                    fontFamily: 'ExpoArabic',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.paragraph(context),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '$formattedAmount ${isArabic ? 'ج.م' : 'EGP'}',
                  style: TextStyle(
                    fontFamily: 'ExpoArabic',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: amountColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyTransactionsState extends StatelessWidget {
  const _EmptyTransactionsState({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color:
                    isDark ? const Color(0xFF142920) : const Color(0xFFEBF6F2),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                CupertinoIcons.creditcard,
                size: 40,
                color: Color(0xFF009663),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isArabic ? 'لا توجد معاملات سابقة' : 'No previous transactions',
              style: TextStyle(
                fontFamily: 'ExpoArabic',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isArabic
                  ? 'ستظهر هنا جميع العمليات وحركات الرصيد الخاصة بمحفظتك.'
                  : 'All wallet transactions and balance changes will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'ExpoArabic',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.paragraph(context),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletErrorState extends StatelessWidget {
  const _WalletErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 56,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'ExpoArabic',
                fontSize: 14,
                color: AppColors.onSurface(context),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF009663),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(
                isArabic ? 'إعادة المحاولة' : 'Retry',
                style: const TextStyle(
                  fontFamily: 'ExpoArabic',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

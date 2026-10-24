import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/di/injection_container.dart' as di;
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/utils/extensions/context_ext.dart';
import 'package:food_user_app/features/order/domain/entities/order.dart';
import 'package:food_user_app/features/order/presentation/cubit/order_history_cubit.dart';
import 'package:food_user_app/features/order/presentation/cubit/order_history_state.dart';
import 'package:food_user_app/features/order/presentation/utils/order_status_mapper.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  static const _screenPadding = 16.0;
  static const _cardRadius = 16.0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<OrderHistoryCubit>()..loadOrders(),
      child: const _OrderHistoryView(),
    );
  }
}

class _OrderHistoryView extends StatefulWidget {
  const _OrderHistoryView();

  @override
  State<_OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<_OrderHistoryView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      context.read<OrderHistoryCubit>().loadMoreOrders();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ColoredBox(
      color: AppColors.scaffoldBackground(context),
      child: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => context.read<OrderHistoryCubit>().refreshOrders(),
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: ClampingScrollPhysics(),
            ),
            slivers: [
              SliverPadding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  OrderHistoryScreen._screenPadding,
                  20,
                  OrderHistoryScreen._screenPadding,
                  0,
                ),
                sliver: SliverToBoxAdapter(
                  child: _OrdersHeader(title: l10n.ordersTitle),
                ),
              ),
              BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
                builder: (context, state) {
                  if (state.status == OrderHistoryStatus.loading &&
                      state.orders.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  }

                  if (state.status == OrderHistoryStatus.error &&
                      state.orders.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: _OrderHistoryErrorView(
                        errorMessage:
                            state.errorMessage ?? context.l10n.errorOccurred,
                        onRetry: () =>
                            context.read<OrderHistoryCubit>().loadOrders(),
                      ),
                    );
                  }

                  if (state.orders.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _OrderHistoryEmptyView(),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      OrderHistoryScreen._screenPadding,
                      20,
                      OrderHistoryScreen._screenPadding,
                      24,
                    ),
                    sliver: SliverList.separated(
                      itemCount: state.orders.length +
                          (state.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= state.orders.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          );
                        }
                        return _OrderCard(order: state.orders[index]);
                      },
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrdersHeader extends StatelessWidget {
  const _OrdersHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          style: AppTextStyles.heading4(context).copyWith(
            color: AppColors.onSurface(context),
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final uiModel = OrderStatusUiModel.fromStatus(
      status: order.status,
      l10n: l10n,
      isDetailScreen: false,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _openOrderDetails(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard(context),
          borderRadius: BorderRadius.circular(OrderHistoryScreen._cardRadius),
          border: Border.all(color: AppColors.border(context), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _OrderCardTopRow(order: order),
            Divider(
              height: 17,
              thickness: 0.5,
              color: AppColors.border(context),
            ),
            _OrderStatusRow(uiModel: uiModel),
            if (uiModel.progressStep != null) ...[
              const SizedBox(height: 16),
              _OrderProgressBar(activeStep: uiModel.progressStep!),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _OrderBadge(
                  label: uiModel.badgeLabel,
                  muted: uiModel.isClosed,
                ),
                _PrimaryActionButton(
                  label: l10n.orderDetails,
                  onTap: () => _openOrderDetails(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openOrderDetails(BuildContext context) async {
    final updated = await context.push<Order?>(
      RouteNames.orderDetailFor(order.id.toString()),
      extra: order,
    );
    if (context.mounted) {
      if (updated != null) {
        context.read<OrderHistoryCubit>().updateOrder(updated);
      }
      context.read<OrderHistoryCubit>().refreshOrders();
    }
  }
}

class _OrderCardTopRow extends StatelessWidget {
  const _OrderCardTopRow({required this.order});

  final Order order;

  String _formatAmount(double amount) {
    if (amount == amount.truncateToDouble()) {
      return amount.toInt().toString();
    }
    return amount.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final restaurantName = order.store?.name ?? context.l10n.orderDefaultStore;
    final restaurantLogo = order.store?.logo;

    final restaurantGroup = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipOval(
          child: restaurantLogo != null && restaurantLogo.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: restaurantLogo,
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Image.asset(
                    AppAssets.orderRestaurantAvatar,
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                  ),
                )
              : Image.asset(
                  AppAssets.orderRestaurantAvatar,
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                ),
        ),
        const SizedBox(width: 4),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 120),
          child: Text(
            restaurantName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.textLink(context).copyWith(
              color: AppColors.onSurface(context),
              fontSize: 10,
              fontWeight: FontWeight.w500,
              height: 1.25,
            ),
          ),
        ),
      ],
    );

    final priceGroup = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.l10n.orderProductsCountParam(order.items.length),
          style: AppTextStyles.caption(context).copyWith(
            color: AppColors.onSurface(context),
            fontSize: 10,
            fontWeight: FontWeight.w400,
            height: 1.25,
          ),
        ),
        const SizedBox(width: 6),
        Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          context.l10n.priceWithCurrency(_formatAmount(order.summary.total)),
          style: AppTextStyles.body(context).copyWith(
            color: AppColors.onSurface(context),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
        ),
      ],
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [restaurantGroup, priceGroup],
    );
  }
}

class _OrderStatusRow extends StatelessWidget {
  const _OrderStatusRow({required this.uiModel});

  final OrderStatusUiModel uiModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final showEta = uiModel.showEta;

    final statusGroup = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _OrderStatusIcon(iconAsset: uiModel.statusIconAsset),
        const SizedBox(width: 8),
        SizedBox(
          width: 151,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                uiModel.shortStatusLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: AppTextStyles.caption(context).copyWith(
                  color: uiModel.statusColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                uiModel.statusLabel,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: AppTextStyles.body(context).copyWith(
                  color: AppColors.onSurface(context),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    final etaGroup = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          l10n.orderEstimatedArrival,
          style: AppTextStyles.caption(context).copyWith(
            color: AppColors.paragraph(context),
            fontSize: 10,
            fontWeight: FontWeight.w400,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.orderEstimatedArrivalRange,
          style: AppTextStyles.body(context).copyWith(
            color: AppColors.onSurface(context),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
        ),
      ],
    );

    return Row(
      mainAxisAlignment: showEta
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [statusGroup, if (showEta) etaGroup],
    );
  }
}

class _OrderStatusIcon extends StatelessWidget {
  const _OrderStatusIcon({required this.iconAsset});

  final String iconAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Image.asset(
        iconAsset,
        width: 30,
        height: 30,
        fit: BoxFit.contain,
      ),
    );
  }
}

class _OrderProgressBar extends StatelessWidget {
  const _OrderProgressBar({required this.activeStep});

  final int activeStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < 4; index++) ...[
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: index <= activeStep
                    ? AppColors.primary
                    : AppColors.border(context).withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(32),
              ),
            ),
          ),
          if (index != 3) const SizedBox(width: 4),
        ],
      ],
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 132,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
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

class _OrderBadge extends StatelessWidget {
  const _OrderBadge({required this.label, required this.muted});

  final String label;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.border(context).withValues(alpha: muted ? 0.35 : 0.55),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppTextStyles.caption(context).copyWith(
          color: muted
              ? AppColors.paragraph(context)
              : AppColors.onSurface(context),
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.3,
        ),
      ),
    );
  }
}

class _OrderHistoryEmptyView extends StatelessWidget {
  const _OrderHistoryEmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppAssets.paymentEmptyIcon,
              width: 80,
              height: 80,
              colorFilter: ColorFilter.mode(
                AppColors.paragraph(context),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.ordersEmptyTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.heading4(context).copyWith(
                color: AppColors.onSurface(context),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.ordersEmptySubtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.body(context).copyWith(
                color: AppColors.paragraph(context),
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderHistoryErrorView extends StatelessWidget {
  const _OrderHistoryErrorView({
    required this.errorMessage,
    required this.onRetry,
  });

  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.body(context).copyWith(
                color: AppColors.onSurface(context),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                context.l10n.tryAgain,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

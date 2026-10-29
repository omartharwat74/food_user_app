import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/di/injection_container.dart' as di;
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/services/snackbar_service.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/app_directional_icons.dart';
import 'package:food_user_app/core/widgets/top_snackbar.dart';
import 'package:food_user_app/core/utils/extensions/context_ext.dart';
import 'package:food_user_app/features/main/presentation/pages/main_layout.dart';
import 'package:food_user_app/features/order/domain/entities/order.dart';
import 'package:food_user_app/features/order/domain/usecases/rate_order_usecase.dart';
import 'package:food_user_app/features/order/presentation/cubit/order_detail_cubit.dart';
import 'package:food_user_app/features/order/presentation/cubit/order_detail_state.dart';
import 'package:food_user_app/features/order/presentation/cubit/order_history_cubit.dart';
import 'package:food_user_app/features/order/presentation/utils/order_status_mapper.dart';
import 'package:food_user_app/features/order/presentation/widgets/order_item_tile.dart';
import 'package:food_user_app/features/support/presentation/cubit/support_ticket_cubit.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

enum OrderDetailsStatus {
  waitingAcceptance,
  preparing,
  courierOnWay,
  delivered,
  cancelled,
}

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({
    super.key,
    required this.orderId,
    this.initialOrder,
    this.status = OrderDetailsStatus.waitingAcceptance,
  });

  final String orderId;
  final Order? initialOrder;
  final OrderDetailsStatus status;

  static const screenPadding = 16.0;
  static const headerTopPadding = 20.0;
  static const contentGap = 20.0;
  static const cardRadius = 16.0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<SupportTicketCubit>()),
        BlocProvider(
          create: (_) => di.sl<OrderDetailCubit>()
            ..loadOrderDetails(orderId, initialOrder: initialOrder),
        ),
      ],
      child: _OrderDetailsScreenContent(
        orderId: orderId,
        fallbackStatus: status,
      ),
    );
  }
}

class _OrderDetailsScreenContent extends StatefulWidget {
  final String orderId;
  final OrderDetailsStatus fallbackStatus;

  const _OrderDetailsScreenContent({
    required this.orderId,
    required this.fallbackStatus,
  });

  @override
  State<_OrderDetailsScreenContent> createState() =>
      _OrderDetailsScreenContentState();
}

class _OrderDetailsScreenContentState
    extends State<_OrderDetailsScreenContent> {
  bool _hasRated = false;
  Locale? _lastLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentLocale = Localizations.localeOf(context);
    if (_lastLocale != null && _lastLocale != currentLocale) {
      context.read<OrderDetailCubit>().loadOrderDetails(widget.orderId);
    }
    _lastLocale = currentLocale;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MultiBlocListener(
      listeners: [
        BlocListener<SupportTicketCubit, SupportTicketState>(
          listener: (context, state) {
            state.maybeWhen(
              success: (ticket) {
                context.push(RouteNames.helpSupport, extra: ticket.id);
              },
              error: (message) {
                di.sl<SnackbarService>().showError(message);
              },
              orElse: () {},
            );
          },
        ),
        BlocListener<OrderDetailCubit, OrderDetailState>(
          listener: (context, state) {
            if (state.status == OrderDetailScreenStatus.cancelSuccess) {
              final msg = state.successMessage ?? l10n.orderCancelDesignOnly;
              di.sl<SnackbarService>().showSuccess(msg);
            } else if (state.status == OrderDetailScreenStatus.error &&
                state.errorMessage != null) {
              di.sl<SnackbarService>().showError(state.errorMessage!);
            }
          },
        ),
      ],
      child: BlocBuilder<OrderDetailCubit, OrderDetailState>(
        builder: (context, state) {
          final order = state.order;

          return PopScope<Order?>(
            canPop: true,
            onPopInvokedWithResult: (didPop, _) {
              if (order != null) {
                try {
                  if (di.sl.isRegistered<OrderHistoryCubit>()) {
                    di.sl<OrderHistoryCubit>().updateOrder(order);
                  }
                } catch (_) {}
              }
            },
            child: Scaffold(
              backgroundColor: AppColors.scaffoldBackground(context),
              body: SafeArea(
                bottom: false,
                child: Builder(
                  builder: (context) {
                    if (state.status == OrderDetailScreenStatus.loading &&
                        order == null) {
                      return const Center(
                        child:
                            CircularProgressIndicator(color: AppColors.primary),
                      );
                    }

                    if (state.status == OrderDetailScreenStatus.error &&
                        order == null) {
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
                                state.errorMessage ??
                                    context.l10n.orderNotFound,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.body(context).copyWith(
                                  color: AppColors.onSurface(context),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => context
                                    .read<OrderDetailCubit>()
                                    .loadOrderDetails(widget.orderId),
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

                    final uiModel = order != null
                        ? OrderStatusUiModel.fromStatus(
                            status: order.status,
                            l10n: l10n,
                            isDetailScreen: true,
                          )
                        : _OrderDetailsConfig.fromStatus(
                            widget.fallbackStatus,
                            l10n,
                          );

                    final showCourier = order != null
                        ? (order.delivery != null)
                        : uiModel.showCourierSection;

                    return Column(
                      children: [
                        Expanded(
                          child: RefreshIndicator(
                            color: AppColors.primary,
                            onRefresh: () => context
                                .read<OrderDetailCubit>()
                                .loadOrderDetails(widget.orderId),
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: ClampingScrollPhysics(),
                              ),
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                OrderDetailsScreen.screenPadding,
                                OrderDetailsScreen.headerTopPadding,
                                OrderDetailsScreen.screenPadding,
                                24,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _OrderDetailsHeader(
                                    title: l10n.trackYourOrder,
                                    showSupport: !uiModel.cancelled,
                                    onBack: () {
                                      if (context.canPop()) {
                                        context.pop(order);
                                      } else {
                                        MainLayout.globalKey.currentState
                                            ?.changeIndex(2);
                                        context.go(RouteNames.home);
                                      }
                                    },
                                    onSupport: () {
                                      context
                                          .read<SupportTicketCubit>()
                                          .createTicket(
                                            subject:
                                                'Order #${order?.code ?? widget.orderId}',
                                            message:
                                                'I need help with order #${order?.code ?? widget.orderId}',
                                          );
                                    },
                                  ),
                                  const SizedBox(
                                    height: OrderDetailsScreen.contentGap,
                                  ),
                                  _OrderStatusSummaryCard(
                                    order: order,
                                    orderId: widget.orderId,
                                    uiModel: uiModel,
                                  ),
                                  const SizedBox(height: 16),
                                  if (showCourier && order?.delivery != null) ...[
                                    _CourierDetailsSection(
                                      delivery: order!.delivery!,
                                      l10n: l10n,
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                  _DeliveryAddressSection(
                                    order: order,
                                    l10n: l10n,
                                  ),
                                  const SizedBox(height: 16),
                                  _OrderItemsSection(
                                    items: order?.items ?? const [],
                                    l10n: l10n,
                                  ),
                                  if (order != null &&
                                      order.notes != null &&
                                      order.notes!.trim().isNotEmpty) ...[
                                    const SizedBox(height: 16),
                                    _OrderNotesSection(
                                      notes: order.notes!,
                                      l10n: l10n,
                                    ),
                                  ],
                                  const SizedBox(height: 16),
                                  _PaymentSummarySection(
                                    order: order,
                                    l10n: l10n,
                                  ),
                                  if (uiModel.showCancellationReason) ...[
                                    const SizedBox(height: 16),
                                    Divider(
                                      height: 1,
                                      thickness: 0.5,
                                      color: AppColors.border(context),
                                    ),
                                    const SizedBox(height: 16),
                                    _CancellationReasonSection(
                                      reason: order?.cancelReason,
                                      l10n: l10n,
                                    ),
                                  ],
                                  if (uiModel.showRateAction &&
                                      order != null &&
                                      !order.isReviewed &&
                                      !_hasRated) ...[
                                    const SizedBox(height: 24),
                                    _PrimaryFilledButton(
                                      label: l10n.rateOrder,
                                      onTap: () =>
                                          _showRatingSheet(context, order),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (uiModel.showCancelAction && order != null)
                          _BottomCancelBar(
                            label: l10n.cancelOrder,
                            isLoading: state.status ==
                                OrderDetailScreenStatus.cancelling,
                            onTap: () =>
                                _showCancelOrderDialog(context, order),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCancelOrderDialog(BuildContext parentContext, Order order) {
    final l10n = AppLocalizations.of(parentContext)!;
    final cubit = parentContext.read<OrderDetailCubit>();

    final reasons = [
      parentContext.l10n.cancelReasonDelay,
      parentContext.l10n.cancelReasonWrongOrder,
      parentContext.l10n.cancelReasonOther,
    ];
    String selectedReason = reasons.first;
    final otherReasonController = TextEditingController();

    showModalBottomSheet<void>(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceCard(parentContext),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final isOther =
                selectedReason == context.l10n.cancelReasonOther;
            final keyboardBottom = MediaQuery.of(context).viewInsets.bottom;

            return Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                16,
                20,
                16,
                keyboardBottom + 20 + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.cancelOrder,
                        style: AppTextStyles.heading4(context).copyWith(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => Navigator.of(sheetContext).pop(),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.close,
                            size: 22,
                            color: AppColors.onSurface(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.cancelOrderConfirmation,
                    style: AppTextStyles.body(context).copyWith(
                      color: AppColors.paragraph(context),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...reasons.map((reason) {
                    final isSelected = selectedReason == reason;
                    return InkWell(
                      onTap: () => setSheetState(() => selectedReason = reason),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.paragraph(context),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              reason,
                              style: AppTextStyles.body(context).copyWith(
                                fontSize: 13,
                                color: AppColors.onSurface(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  if (isOther) ...[
                    const SizedBox(height: 8),
                    TextField(
                      controller: otherReasonController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: context.l10n.cancelOrderOtherHint,
                        hintStyle: AppTextStyles.inputHint(context).copyWith(
                          fontSize: 12,
                        ),
                        filled: true,
                        fillColor: AppColors.scaffoldBackground(context),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.border(context),
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _OutlineActionButton(
                          label: context.l10n.cancelOrderDismiss,
                          onTap: () => Navigator.of(sheetContext).pop(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _PrimaryFilledButton(
                          label: context.l10n.confirmCancel,
                          backgroundColor: AppColors.primary,
                          onTap: () {
                            final finalReason = isOther
                                ? (otherReasonController.text.trim().isNotEmpty
                                    ? otherReasonController.text.trim()
                                    : context.l10n.cancelReasonDelay)
                                : selectedReason;
                            Navigator.of(sheetContext).pop();
                            cubit.cancelOrder(
                              orderId: order.id.toString(),
                              reason: finalReason,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showRatingSheet(BuildContext context, Order? order) {
    final cubit = context.read<OrderDetailCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.scaffoldBackground(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9,
      ),
      builder: (sheetContext) => _OrderRatingSheet(
        order: order,
        cubit: cubit,
        onSkip: () => Navigator.of(sheetContext).pop(),
        onSubmitSuccess: () {
          Navigator.of(sheetContext).pop();
          if (mounted) {
            setState(() => _hasRated = true);
          }
          showTopSnackBar(
            context,
            AppLocalizations.of(context)!.ratingSubmittedDesignOnly,
            isError: false,
          );
        },
      ),
    );
  }
}

class _OrderDetailsConfig {
  static OrderStatusUiModel fromStatus(
    OrderDetailsStatus status,
    AppLocalizations l10n,
  ) {
    return switch (status) {
      OrderDetailsStatus.waitingAcceptance => OrderStatusUiModel.fromStatus(
          status: 'pending',
          l10n: l10n,
          isDetailScreen: true,
        ),
      OrderDetailsStatus.preparing => OrderStatusUiModel.fromStatus(
          status: 'confirmed',
          l10n: l10n,
          isDetailScreen: true,
        ),
      OrderDetailsStatus.courierOnWay => OrderStatusUiModel.fromStatus(
          status: 'assigned',
          l10n: l10n,
          isDetailScreen: true,
        ),
      OrderDetailsStatus.delivered => OrderStatusUiModel.fromStatus(
          status: 'delivered',
          l10n: l10n,
          isDetailScreen: true,
        ),
      OrderDetailsStatus.cancelled => OrderStatusUiModel.fromStatus(
          status: 'cancelled',
          l10n: l10n,
          isDetailScreen: true,
        ),
    };
  }
}

class _OrderDetailsHeader extends StatelessWidget {
  const _OrderDetailsHeader({
    required this.title,
    required this.showSupport,
    required this.onBack,
    required this.onSupport,
  });

  final String title;
  final bool showSupport;
  final VoidCallback onBack;
  final VoidCallback onSupport;

  @override
  Widget build(BuildContext context) {
    final titleRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onBack,
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
        Flexible(
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
      ],
    );

    if (!showSupport) {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: titleRow,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: titleRow),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onSupport,
          child: SizedBox(
            width: 28,
            height: 28,
            child: SvgPicture.asset(
              AppAssets.orderSupportIcon,
              width: 28,
              height: 28,
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderStatusSummaryCard extends StatelessWidget {
  const _OrderStatusSummaryCard({
    required this.order,
    this.orderId,
    required this.uiModel,
  });

  final Order? order;
  final String? orderId;
  final OrderStatusUiModel uiModel;

  String _formatAmount(double amount) {
    if (amount == amount.truncateToDouble()) {
      return amount.toInt().toString();
    }
    return amount.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final restaurantName = order?.store?.name ?? l10n.orderRestaurantAzAlSham;
    final totalLabel = order != null
        ? context.l10n.priceWithCurrency(_formatAmount(order!.summary.total))
        : l10n.orderTotal;
    final productsCount = order != null
        ? context.l10n.orderProductsCountParam(order!.items.length)
        : l10n.orderProductsCount;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        borderRadius: BorderRadius.circular(OrderDetailsScreen.cardRadius),
        border: Border.all(color: AppColors.border(context), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _RestaurantPriceRow(
            order: order,
            orderId: orderId,
            restaurantName: restaurantName,
            totalLabel: totalLabel,
            productsLabel: productsCount,
          ),
          Divider(
            height: 17,
            thickness: 0.5,
            color: AppColors.border(context),
          ),
          _StatusEtaRow(uiModel: uiModel, l10n: l10n),
          if (uiModel.progressStep != null) ...[
            const SizedBox(height: 16),
            _OrderProgressBar(activeStep: uiModel.progressStep!),
          ],
        ],
      ),
    );
  }
}

class _RestaurantPriceRow extends StatelessWidget {
  const _RestaurantPriceRow({
    required this.order,
    this.orderId,
    required this.restaurantName,
    required this.totalLabel,
    required this.productsLabel,
  });

  final Order? order;
  final String? orderId;
  final String restaurantName;
  final String totalLabel;
  final String productsLabel;

  @override
  Widget build(BuildContext context) {
    final logo = order?.store?.logo;

    final rawCode = order?.code.isNotEmpty == true
        ? order!.code
        : (order != null && order!.id > 0
            ? order!.id.toString()
            : (orderId ?? ''));
    final orderCode = rawCode.isNotEmpty
        ? (rawCode.startsWith('#') ? rawCode : '#$rawCode')
        : '';

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dotColor = isDark
        ? (Colors.grey[600] ?? Theme.of(context).dividerColor)
        : const Color(0xFFB6B6B6);

    final productsCountStyle = AppTextStyles.caption(context).copyWith(
      color: AppColors.onSurface(context),
      fontSize: 10,
      fontWeight: FontWeight.w400,
      height: 1.25,
    );

    final restaurantGroup = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipOval(
          child: logo != null && logo.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: logo,
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
        Flexible(
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
        if (orderCode.isNotEmpty) ...[
          const SizedBox(width: 6),
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            orderCode,
            maxLines: 1,
            textDirection: TextDirection.ltr,
            style: productsCountStyle,
          ),
        ],
      ],
    );

    final priceGroup = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          productsLabel,
          style: productsCountStyle,
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
          totalLabel,
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: restaurantGroup),
        const SizedBox(width: 8),
        priceGroup,
      ],
    );
  }
}

class _StatusEtaRow extends StatelessWidget {
  const _StatusEtaRow({required this.uiModel, required this.l10n});

  final OrderStatusUiModel uiModel;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final statusGroup = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _OrderStatusIcon(
          iconAsset: uiModel.statusIconAsset,
          cancelled: uiModel.cancelled,
        ),
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

    if (!uiModel.showEta) {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: statusGroup,
      );
    }

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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [statusGroup, etaGroup],
    );
  }
}

class _OrderStatusIcon extends StatelessWidget {
  const _OrderStatusIcon({
    required this.iconAsset,
    required this.cancelled,
  });

  final String iconAsset;
  final bool cancelled;

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

class _CourierDetailsSection extends StatelessWidget {
  const _CourierDetailsSection({
    required this.delivery,
    required this.l10n,
  });

  final OrderDelivery delivery;
  final AppLocalizations l10n;

  Future<void> _callCourier(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final courierName = delivery.name?.isNotEmpty == true
        ? delivery.name!
        : l10n.orderCourierName;
    final courierPhone = delivery.phone ?? l10n.orderCourierPhone;

    final courierInfo = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: delivery.image != null && delivery.image!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: delivery.image!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => _buildCourierAvatar(),
                )
              : _buildCourierAvatar(),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                courierName,
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.footerSecondary(context).copyWith(
                  color: AppColors.onSurface(context),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _callCourier(courierPhone),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppAssets.orderPhoneIcon,
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        courierPhone,
                        textAlign: TextAlign.start,
                        style: AppTextStyles.body(context).copyWith(
                          color: AppColors.onSurface(context),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );

    final courierRating = delivery.rating;
    final ratingCount = delivery.ratingCount;
    final ratingBadge = (courierRating != null && courierRating > 0 && ratingCount > 0)
        ? Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.border(context).withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  courierRating.toStringAsFixed(1),
                  style: AppTextStyles.caption(context).copyWith(
                    color: AppColors.onSurface(context),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
                const SizedBox(width: 2),
                SvgPicture.asset(
                  AppAssets.orderRatingStarIcon,
                  width: 14,
                  height: 14,
                ),
              ],
            ),
          )
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.courierDetails,
          textAlign: TextAlign.start,
          style: AppTextStyles.heading4(context).copyWith(
            color: AppColors.onSurface(context),
            fontSize: 15,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            courierInfo,
            ?ratingBadge,
          ],
        ),
        const SizedBox(height: 16),
        Divider(
          height: 1,
          thickness: 0.5,
          color: AppColors.border(context),
        ),
      ],
    );
  }
}

class _DeliveryAddressSection extends StatelessWidget {
  const _DeliveryAddressSection({
    required this.order,
    required this.l10n,
  });

  final Order? order;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isSelfPickup = order?.selfPickup == true;
    final addressText = isSelfPickup
        ? context.l10n.orderSelfPickupFromStore
        : (order?.address?.fullAddress ??
            order?.address?.name ??
            l10n.deliveryAddress);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.deliverTo,
          textAlign: TextAlign.start,
          style: AppTextStyles.heading4(context).copyWith(
            color: AppColors.onSurface(context),
            fontSize: 15,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppAssets.orderLocationIcon,
              width: 16,
              height: 16,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                addressText,
                textAlign: TextAlign.start,
                style: AppTextStyles.body(context).copyWith(
                  color: AppColors.paragraph(context),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Divider(
          height: 1,
          thickness: 0.5,
          color: AppColors.border(context),
        ),
      ],
    );
  }
}

class _OrderItemsSection extends StatelessWidget {
  const _OrderItemsSection({
    required this.items,
    required this.l10n,
  });

  final List<OrderItem> items;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.orderItemsTitle,
            textAlign: TextAlign.start,
            style: AppTextStyles.heading4(context).copyWith(
              color: AppColors.onSurface(context),
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          OrderItemTile(item: null, l10n: l10n),
          const SizedBox(height: 16),
          Divider(
            height: 1,
            thickness: 0.5,
            color: AppColors.border(context),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.orderItemsTitle,
          textAlign: TextAlign.start,
          style: AppTextStyles.heading4(context).copyWith(
            color: AppColors.onSurface(context),
            fontSize: 15,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < items.length; i++) ...[
          OrderItemTile(item: items[i], l10n: l10n),
          if (i < items.length - 1) ...[
            const SizedBox(height: 12),
            Divider(
              height: 1,
              thickness: 0.5,
              color: AppColors.border(context),
            ),
            const SizedBox(height: 12),
          ],
        ],
        const SizedBox(height: 16),
        Divider(
          height: 1,
          thickness: 0.5,
          color: AppColors.border(context),
        ),
      ],
    );
  }
}

class _OrderNotesSection extends StatelessWidget {
  const _OrderNotesSection({
    required this.notes,
    required this.l10n,
  });

  final String notes;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.orderNotesTitle,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontFamily: 'Expo Arabic',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            height: 21.0 / 15.0,
            color: AppColors.onSurface(context),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          notes,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontFamily: 'Expo Arabic',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 15.6 / 12.0,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.paragraph(context)
                : const Color(0xFF474747),
          ),
        ),
        const SizedBox(height: 16),
        Divider(
          height: 1,
          thickness: 0.5,
          color: AppColors.border(context),
        ),
      ],
    );
  }
}

class _PaymentSummarySection extends StatelessWidget {
  const _PaymentSummarySection({
    required this.order,
    required this.l10n,
  });

  final Order? order;
  final AppLocalizations l10n;

  String _formatAmount(double amount) {
    if (amount == amount.truncateToDouble()) {
      return amount.toInt().toString();
    }
    return amount.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    if (order == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.paymentSummary,
            textAlign: TextAlign.start,
            style: AppTextStyles.heading4(context).copyWith(
              color: AppColors.onSurface(context),
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          _SummaryRow(label: l10n.orderSubtotal, value: l10n.orderSubtotalValue),
          const SizedBox(height: 12),
          _SummaryRow(
            label: l10n.orderDeliveryFee,
            value: l10n.orderDeliveryFeeValue,
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            label: l10n.orderDiscount,
            value: l10n.orderDiscountValue,
          ),
          const SizedBox(height: 12),
          Divider(
            height: 1,
            thickness: 0.5,
            color: AppColors.border(context),
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            label: l10n.orderGrandTotal,
            value: l10n.orderTotal,
            emphasized: true,
          ),
        ],
      );
    }

    final summary = order!.summary;
    final subtotal = summary.itemsSubtotal > 0
        ? summary.itemsSubtotal
        : summary.itemsTotal;
    final deliveryFee = order!.selfPickup ? 0.0 : summary.delivery;
    final discount = summary.couponDiscount + summary.offerDiscount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.paymentSummary,
          textAlign: TextAlign.start,
          style: AppTextStyles.heading4(context).copyWith(
            color: AppColors.onSurface(context),
            fontSize: 15,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 12),
        _SummaryRow(
          label: l10n.orderSubtotal,
          value: context.l10n.priceWithCurrency(_formatAmount(subtotal)),
        ),
        const SizedBox(height: 12),
        _SummaryRow(
          label: l10n.orderDeliveryFee,
          value: order!.selfPickup
              ? context.l10n.priceWithCurrency('0')
              : context.l10n.priceWithCurrency(_formatAmount(deliveryFee)),
        ),
        if (discount > 0) ...[
          const SizedBox(height: 12),
          _SummaryRow(
            label: l10n.orderDiscount,
            value: context.l10n.priceWithCurrency(_formatAmount(discount)),
          ),
        ],
        if (summary.tax > 0) ...[
          const SizedBox(height: 12),
          _SummaryRow(
            label: l10n.tax,
            value: context.l10n.priceWithCurrency(_formatAmount(summary.tax)),
          ),
        ],
        const SizedBox(height: 12),
        Divider(
          height: 1,
          thickness: 0.5,
          color: AppColors.border(context),
        ),
        const SizedBox(height: 12),
        _SummaryRow(
          label: l10n.orderGrandTotal,
          value: context.l10n.priceWithCurrency(_formatAmount(summary.total)),
          emphasized: true,
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final style = emphasized
        ? AppTextStyles.body(context).copyWith(
            color: AppColors.onSurface(context),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.25,
          )
        : AppTextStyles.body(context).copyWith(
            color: AppColors.onSurface(context),
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.3,
          );

    final valueStyle = emphasized
        ? style.copyWith(fontWeight: FontWeight.w500)
        : style.copyWith(fontWeight: FontWeight.w500);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, textAlign: TextAlign.start, style: style),
        Text(value, textAlign: TextAlign.start, style: valueStyle),
      ],
    );
  }
}

class _CancellationReasonSection extends StatelessWidget {
  const _CancellationReasonSection({
    required this.reason,
    required this.l10n,
  });

  final String? reason;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final displayText = reason?.isNotEmpty == true
        ? reason!
        : l10n.cancellationReasonSample;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.cancellationReasonTitle,
          textAlign: TextAlign.start,
          style: AppTextStyles.heading4(context).copyWith(
            color: AppColors.onSurface(context),
            fontSize: 15,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          displayText,
          textAlign: TextAlign.start,
          style: AppTextStyles.footerSecondary(context).copyWith(
            color: AppColors.paragraph(context),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _BottomCancelBar extends StatelessWidget {
  const _BottomCancelBar({
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, bottomSafe + 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 4,
          ),
        ],
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: isLoading ? null : onTap,
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primary, width: 0.5),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                )
              : Text(
                  label,
                  style: AppTextStyles.textLink(context).copyWith(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
        ),
      ),
    );
  }
}

class _PrimaryFilledButton extends StatelessWidget {
  const _PrimaryFilledButton({
    required this.label,
    required this.onTap,
    this.backgroundColor,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
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

class _OrderRatingSheet extends StatefulWidget {
  const _OrderRatingSheet({
    required this.order,
    required this.cubit,
    required this.onSkip,
    required this.onSubmitSuccess,
  });

  final Order? order;
  final OrderDetailCubit cubit;
  final VoidCallback onSkip;
  final VoidCallback onSubmitSuccess;

  @override
  State<_OrderRatingSheet> createState() => _OrderRatingSheetState();
}

class _OrderRatingSheetState extends State<_OrderRatingSheet> {
  int _restaurantRating = 0;
  int _courierRating = 0;
  bool _isSubmitting = false;
  final _restaurantFeedbackController = TextEditingController();
  final _courierFeedbackController = TextEditingController();
  final _restaurantFeedbackFocusNode = FocusNode();
  final _courierFeedbackFocusNode = FocusNode();

  @override
  void dispose() {
    _restaurantFeedbackController.dispose();
    _courierFeedbackController.dispose();
    _restaurantFeedbackFocusNode.dispose();
    _courierFeedbackFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submitRating() async {
    final l10n = AppLocalizations.of(context)!;
    final order = widget.order;
    final hasCourier = order?.delivery != null;

    if (_restaurantRating == 0) {
      showTopSnackBar(context, l10n.rateStoreRequired, isError: true);
      return;
    }

    if (hasCourier && _courierRating == 0) {
      showTopSnackBar(context, l10n.rateCourierRequired, isError: true);
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);

    final storeId =
        order?.store?.id ?? int.tryParse(order?.branchId ?? '') ?? 1;
    final deliveryId = order?.delivery?.id;

    final orderId = order?.id ?? 0;

    final params = RateOrderParams(
      orderId: orderId,
      storeId: storeId,
      rating: _restaurantRating,
      comment: _restaurantFeedbackController.text.trim().isNotEmpty
          ? _restaurantFeedbackController.text.trim()
          : null,
      deliveryId: deliveryId,
      deliveryRating: hasCourier ? _courierRating : null,
      deliveryComment: hasCourier &&
              _courierFeedbackController.text.trim().isNotEmpty
          ? _courierFeedbackController.text.trim()
          : null,
    );

    final result = await widget.cubit.submitRating(params);

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    result.fold(
      (failure) {
        showTopSnackBar(context, failure.message, isError: true);
      },
      (_) {
        widget.onSubmitSuccess();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomSafe = MediaQuery.paddingOf(context).bottom;
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final order = widget.order;
    final hasCourier = order?.delivery != null;

    final storeName = (order?.store?.name.isNotEmpty == true)
        ? order!.store!.name
        : l10n.orderRestaurantAzAlSham;
    final storeLogo = order?.store?.logo;

    final courierName = (order?.delivery?.name?.isNotEmpty == true)
        ? order!.delivery!.name!
        : l10n.orderCourierName;
    final courierImage = order?.delivery?.image;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 20),
                child: Column(
                  children: [
                    Text(
                      l10n.rateOrderTitle,
                      style: AppTextStyles.heading4(context).copyWith(
                        color: AppColors.onSurface(context),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Divider(
                      height: 1,
                      thickness: 0.5,
                      color: AppColors.border(context),
                    ),
                    const SizedBox(height: 16),
                    _RatingTargetSection(
                      imageUrl: storeLogo,
                      fallbackAsset: AppAssets.orderRestaurantAvatar,
                      name: storeName,
                      rating: _restaurantRating,
                      feedbackController: _restaurantFeedbackController,
                      feedbackFocusNode: _restaurantFeedbackFocusNode,
                      feedbackLabel: l10n.yourRating,
                      feedbackHint: l10n.ratingFeedbackHint,
                      onRatingChanged: (value) =>
                          setState(() => _restaurantRating = value),
                      circularImage: true,
                    ),
                    if (hasCourier) ...[
                      const SizedBox(height: 16),
                      Divider(
                        height: 1,
                        thickness: 0.5,
                        color: AppColors.border(context),
                      ),
                      const SizedBox(height: 16),
                      _RatingTargetSection(
                        imageUrl: courierImage,
                        fallbackAsset: AppAssets.orderCourierAvatar,
                        name: courierName,
                        rating: _courierRating,
                        feedbackController: _courierFeedbackController,
                        feedbackFocusNode: _courierFeedbackFocusNode,
                        feedbackLabel: l10n.yourRating,
                        feedbackHint: l10n.ratingFeedbackHint,
                        onRatingChanged: (value) =>
                            setState(() => _courierRating = value),
                        circularImage: false,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsetsDirectional.fromSTEB(
                16,
                16,
                16,
                16 + bottomSafe,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard(context),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withValues(alpha: 0.08),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _OutlineActionButton(
                      label: l10n.skipRating,
                      onTap: _isSubmitting ? () {} : widget.onSkip,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _PrimaryFilledButton(
                      label: l10n.submitRating,
                      isLoading: _isSubmitting,
                      onTap: _isSubmitting ? () {} : _submitRating,
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

class _RatingTargetSection extends StatelessWidget {
  const _RatingTargetSection({
    this.imageUrl,
    required this.fallbackAsset,
    required this.name,
    required this.rating,
    required this.feedbackController,
    required this.feedbackFocusNode,
    required this.feedbackLabel,
    required this.feedbackHint,
    required this.onRatingChanged,
    required this.circularImage,
  });

  final String? imageUrl;
  final String fallbackAsset;
  final String name;
  final int rating;
  final TextEditingController feedbackController;
  final FocusNode feedbackFocusNode;
  final String feedbackLabel;
  final String feedbackHint;
  final ValueChanged<int> onRatingChanged;
  final bool circularImage;

  Widget _buildAvatar() {
    if (imageUrl != null && imageUrl!.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildFallbackImage(),
        errorWidget: (context, url, error) => _buildFallbackImage(),
      );
    }
    return _buildFallbackImage();
  }

  Widget _buildFallbackImage() {
    if (fallbackAsset == AppAssets.orderCourierAvatar) {
      return _buildCourierAvatar();
    }
    return Image.asset(fallbackAsset, width: 60, height: 60, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(circularImage ? 30 : 12),
      child: _buildAvatar(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          children: [
            image,
            const SizedBox(height: 8),
            Text(
              name,
              textAlign: TextAlign.center,
              style: AppTextStyles.heading4(context).copyWith(
                color: AppColors.onSurface(context),
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var star = 1; star <= 5; star++) ...[
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onRatingChanged(star),
                      child: SvgPicture.asset(
                        star <= rating
                            ? AppAssets.orderRatingStarIcon
                            : AppAssets.orderRatingStarOutlineIcon,
                        width: 32,
                        height: 32,
                      ),
                    ),
                    if (star != 5) const SizedBox(width: 16),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          feedbackLabel,
          textAlign: TextAlign.start,
          style: AppTextStyles.footerSecondary(context).copyWith(
            color: AppColors.onSurface(context),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: feedbackController,
          focusNode: feedbackFocusNode,
          minLines: 3,
          maxLines: 4,
          textAlign: TextAlign.start,
          cursorColor: AppColors.cursor(context),
          style: AppTextStyles.inputText(context).copyWith(fontSize: 12),
          decoration: InputDecoration(
            hintText: feedbackHint,
            hintStyle: AppTextStyles.inputHint(
              context,
            ).copyWith(color: AppColors.hint(context), fontSize: 12),
            filled: true,
            fillColor: AppColors.surfaceCard(context),
            contentPadding: const EdgeInsetsDirectional.fromSTEB(
              16,
              16,
              16,
              16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.border(context),
                width: 0.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.border(context),
                width: 0.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.fieldFocusBorder(context),
                width: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildCourierAvatar() {
  final asset = AppAssets.orderCourierAvatar;
  if (asset.toLowerCase().endsWith('.svg')) {
    return SvgPicture.asset(asset, width: 60, height: 60, fit: BoxFit.cover);
  }
  return Image.asset(asset, width: 60, height: 60, fit: BoxFit.cover);
}

class _OutlineActionButton extends StatelessWidget {
  const _OutlineActionButton({required this.label, required this.onTap});

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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary, width: 0.5),
        ),
        child: Text(
          label,
          style: AppTextStyles.textLink(context).copyWith(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.25,
          ),
        ),
      ),
    );
  }
}

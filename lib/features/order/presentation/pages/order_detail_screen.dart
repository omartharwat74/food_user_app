import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/keyboard_dismiss_on_tap.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/di/injection_container.dart' as di;
import 'package:food_user_app/features/support/presentation/cubit/support_ticket_cubit.dart';
import 'package:food_user_app/core/services/snackbar_service.dart';
import 'package:food_user_app/core/widgets/app_directional_icons.dart';

enum OrderDetailsStatus {
  waitingAcceptance,
  preparing,
  courierOnWay,
  delivered,
  cancelled,
}

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({
    super.key,
    required this.orderId,
    required this.status,
  });

  final String orderId;
  final OrderDetailsStatus status;

  static const screenPadding = 16.0;
  static const headerTopPadding = 20.0;
  static const contentGap = 20.0;
  static const cardRadius = 16.0;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<SupportTicketCubit>(),
      child: _OrderDetailsScreenContent(
        orderId: widget.orderId,
        status: widget.status,
      ),
    );
  }
}

class _OrderDetailsScreenContent extends StatefulWidget {
  final String orderId;
  final OrderDetailsStatus status;

  const _OrderDetailsScreenContent({
    required this.orderId,
    required this.status,
  });

  @override
  State<_OrderDetailsScreenContent> createState() =>
      _OrderDetailsScreenContentState();
}

class _OrderDetailsScreenContentState
    extends State<_OrderDetailsScreenContent> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final config = _OrderDetailsConfig.fromStatus(widget.status, l10n);

    return BlocListener<SupportTicketCubit, SupportTicketState>(
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
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground(context),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
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
                        showSupport: config.showSupportAction,
                        onSupport: () {
                          context.read<SupportTicketCubit>().createTicket(
                            subject: 'Order #${widget.orderId}',
                            message:
                                'I need help with order #${widget.orderId}',
                          );
                        },
                      ),
                      const SizedBox(height: OrderDetailsScreen.contentGap),
                      _OrderStatusSummaryCard(config: config),
                      const SizedBox(height: 16),
                      if (config.showCourierSection) ...[
                        _CourierDetailsSection(l10n: l10n),
                        const SizedBox(height: 16),
                      ],
                      _DeliveryAddressSection(l10n: l10n),
                      const SizedBox(height: 16),
                      _OrderItemsSection(l10n: l10n),
                      const SizedBox(height: 16),
                      _PaymentSummarySection(l10n: l10n),
                      if (config.showCancellationReason) ...[
                        const SizedBox(height: 16),
                        Divider(
                          height: 1,
                          thickness: 0.5,
                          color: AppColors.border(context),
                        ),
                        const SizedBox(height: 16),
                        _CancellationReasonSection(l10n: l10n),
                      ],
                      if (config.showRateAction) ...[
                        const SizedBox(height: 24),
                        _PrimaryFilledButton(
                          label: l10n.rateOrder,
                          onTap: () => _showRatingSheet(context),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (config.showCancelAction)
                _BottomCancelBar(
                  label: l10n.cancelOrder,
                  onTap: () {
                    // TODO: Cancel order through real order API.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.orderCancelDesignOnly)),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRatingSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.scaffoldBackground(context),
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height),
      builder: (sheetContext) => _OrderRatingSheet(
        onSkip: () => Navigator.of(sheetContext).pop(),
        onSubmit: () {
          // TODO: Submit rating through real rating API.
          Navigator.of(sheetContext).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.ratingSubmittedDesignOnly,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OrderDetailsConfig {
  const _OrderDetailsConfig({
    required this.shortStatusLabel,
    required this.statusLabel,
    required this.statusColor,
    required this.statusIconAsset,
    required this.showEta,
    required this.progressStep,
    required this.showCourierSection,
    required this.showCancelAction,
    required this.showRateAction,
    required this.showCancellationReason,
    required this.showSupportAction,
    required this.cancelled,
  });

  final String shortStatusLabel;
  final String statusLabel;
  final Color statusColor;
  final String statusIconAsset;
  final bool showEta;
  final int? progressStep;
  final bool showCourierSection;
  final bool showCancelAction;
  final bool showRateAction;
  final bool showCancellationReason;
  final bool showSupportAction;
  final bool cancelled;

  static _OrderDetailsConfig fromStatus(
    OrderDetailsStatus status,
    AppLocalizations l10n,
  ) {
    return switch (status) {
      OrderDetailsStatus.waitingAcceptance => _OrderDetailsConfig(
        shortStatusLabel: l10n.orderWaitingAcceptanceShort,
        statusLabel: l10n.orderWaitingAcceptance,
        statusColor: AppColors.statusWarning,
        statusIconAsset: AppAssets.orderReceiptRollIcon,
        showEta: true,
        progressStep: 0,
        showCourierSection: false,
        showCancelAction: true,
        showRateAction: false,
        showCancellationReason: false,
        showSupportAction: true,
        cancelled: false,
      ),
      OrderDetailsStatus.preparing => _OrderDetailsConfig(
        shortStatusLabel: l10n.orderAcceptedShort,
        statusLabel: l10n.orderPreparing,
        statusColor: AppColors.success,
        statusIconAsset: AppAssets.orderAcceptedIcon,
        showEta: true,
        progressStep: 1,
        showCourierSection: false,
        showCancelAction: false,
        showRateAction: false,
        showCancellationReason: false,
        showSupportAction: true,
        cancelled: false,
      ),
      OrderDetailsStatus.courierOnWay => _OrderDetailsConfig(
        shortStatusLabel: l10n.orderHandedToCourierShort,
        statusLabel: l10n.orderCourierOnWay,
        statusColor: AppColors.primary,
        statusIconAsset: AppAssets.orderCourierOnWayIcon,
        showEta: true,
        progressStep: 2,
        showCourierSection: true,
        showCancelAction: false,
        showRateAction: false,
        showCancellationReason: false,
        showSupportAction: true,
        cancelled: false,
      ),
      OrderDetailsStatus.delivered => _OrderDetailsConfig(
        shortStatusLabel: l10n.orderDeliveredShort,
        statusLabel: l10n.orderDelivered,
        statusColor: AppColors.statusClosed,
        statusIconAsset: AppAssets.orderDeliveredStatus,
        showEta: false,
        progressStep: null,
        showCourierSection: true,
        showCancelAction: false,
        showRateAction: true,
        showCancellationReason: false,
        showSupportAction: true,
        cancelled: false,
      ),
      OrderDetailsStatus.cancelled => _OrderDetailsConfig(
        shortStatusLabel: l10n.orderCancelledShort,
        statusLabel: l10n.orderYouCancelled,
        statusColor: AppColors.error,
        statusIconAsset: AppAssets.orderTornReceiptIcon,
        showEta: false,
        progressStep: null,
        showCourierSection: false,
        showCancelAction: false,
        showRateAction: false,
        showCancellationReason: true,
        showSupportAction: false,
        cancelled: true,
      ),
    };
  }
}

class _OrderDetailsHeader extends StatelessWidget {
  const _OrderDetailsHeader({
    required this.title,
    required this.showSupport,
    required this.onSupport,
  });

  final String title;
  final bool showSupport;
  final VoidCallback onSupport;

  @override
  Widget build(BuildContext context) {
    final titleRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => context.pop(),
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
  const _OrderStatusSummaryCard({required this.config});

  final _OrderDetailsConfig config;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground(context),
        borderRadius: BorderRadius.circular(OrderDetailsScreen.cardRadius),
        border: Border.all(color: AppColors.border(context), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _RestaurantPriceRow(
            restaurantName: l10n.orderRestaurantAzAlSham,
            totalLabel: l10n.orderTotal,
            productsLabel: l10n.orderProductsCount,
          ),
          Divider(height: 17, thickness: 0.5, color: AppColors.border(context)),
          _StatusEtaRow(config: config, l10n: l10n),
          if (config.progressStep != null) ...[
            const SizedBox(height: 16),
            _OrderProgressBar(activeStep: config.progressStep!),
          ],
        ],
      ),
    );
  }
}

class _RestaurantPriceRow extends StatelessWidget {
  const _RestaurantPriceRow({
    required this.restaurantName,
    required this.totalLabel,
    required this.productsLabel,
  });

  final String restaurantName;
  final String totalLabel;
  final String productsLabel;

  @override
  Widget build(BuildContext context) {
    final restaurantGroup = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipOval(
          child: Image.asset(
            AppAssets.orderRestaurantAvatar,
            width: 20,
            height: 20,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          restaurantName,
          style: AppTextStyles.textLink(context).copyWith(
            color: AppColors.onSurface(context),
            fontSize: 10,
            fontWeight: FontWeight.w500,
            height: 1.25,
          ),
        ),
      ],
    );

    final priceGroup = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          totalLabel,
          style: AppTextStyles.body(context).copyWith(
            color: AppColors.onSurface(context),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.3,
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
          productsLabel,
          style: AppTextStyles.caption(context).copyWith(
            color: AppColors.onSurface(context),
            fontSize: 10,
            fontWeight: FontWeight.w400,
            height: 1.25,
          ),
        ),
      ],
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [restaurantGroup, priceGroup],
    );
  }
}

class _StatusEtaRow extends StatelessWidget {
  const _StatusEtaRow({required this.config, required this.l10n});

  final _OrderDetailsConfig config;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final statusGroup = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _OrderStatusIcon(
          iconAsset: config.statusIconAsset,
          cancelled: config.cancelled,
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 151,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                config.shortStatusLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: AppTextStyles.caption(context).copyWith(
                  color: config.statusColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                config.statusLabel,
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

    if (!config.showEta) {
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
  const _OrderStatusIcon({required this.iconAsset, required this.cancelled});

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
      child: Image.asset(iconAsset, width: 30, height: 30, fit: BoxFit.contain),
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
  const _CourierDetailsSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final courierInfo = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _buildCourierAvatar(),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 105,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.orderCourierName,
                textAlign: TextAlign.start,
                style: AppTextStyles.footerSecondary(context).copyWith(
                  color: AppColors.onSurface(context),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    AppAssets.orderPhoneIcon,
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n.orderCourierPhone,
                    textAlign: TextAlign.start,
                    style: AppTextStyles.body(context).copyWith(
                      color: AppColors.onSurface(context),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    final ratingBadge = Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.border(context).withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.orderCourierRating,
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
    );

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
          children: [courierInfo, ratingBadge],
        ),
        const SizedBox(height: 16),
        Divider(height: 1, thickness: 0.5, color: AppColors.border(context)),
      ],
    );
  }
}

class _DeliveryAddressSection extends StatelessWidget {
  const _DeliveryAddressSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
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
                l10n.deliveryAddress,
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
        Divider(height: 1, thickness: 0.5, color: AppColors.border(context)),
      ],
    );
  }
}

class _OrderItemsSection extends StatelessWidget {
  const _OrderItemsSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
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
        _OrderItemRow(l10n: l10n),
        const SizedBox(height: 12),
        Divider(height: 1, thickness: 0.5, color: AppColors.border(context)),
        const SizedBox(height: 12),
        _OrderItemRow(l10n: l10n),
        const SizedBox(height: 16),
        Divider(height: 1, thickness: 0.5, color: AppColors.border(context)),
      ],
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  const _OrderItemRow({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final productGroup = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.surfaceCard(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border(context), width: 0.5),
          ),
          alignment: Alignment.center,
          child: Image.asset(
            AppAssets.orderProductImage,
            width: 46,
            height: 23,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.orderProductName,
              textAlign: TextAlign.start,
              style: AppTextStyles.body(context).copyWith(
                color: AppColors.onSurface(context),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.orderProductPrice,
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
      ],
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        productGroup,
        Text(
          l10n.orderQuantity(2),
          style: AppTextStyles.body(context).copyWith(
            color: AppColors.paragraph(context),
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

class _PaymentSummarySection extends StatelessWidget {
  const _PaymentSummarySection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
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
        _SummaryRow(label: l10n.orderDiscount, value: l10n.orderDiscountValue),
        const SizedBox(height: 12),
        Divider(height: 1, thickness: 0.5, color: AppColors.border(context)),
        const SizedBox(height: 12),
        _SummaryRow(
          label: l10n.orderGrandTotal,
          value: l10n.orderTotal,
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
  const _CancellationReasonSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
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
          l10n.cancellationReasonSample,
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
  const _BottomCancelBar({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

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
      ),
    );
  }
}

class _PrimaryFilledButton extends StatelessWidget {
  const _PrimaryFilledButton({required this.label, required this.onTap});

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

class _OrderRatingSheet extends StatefulWidget {
  const _OrderRatingSheet({required this.onSkip, required this.onSubmit});

  final VoidCallback onSkip;
  final VoidCallback onSubmit;

  @override
  State<_OrderRatingSheet> createState() => _OrderRatingSheetState();
}

class _OrderRatingSheetState extends State<_OrderRatingSheet> {
  int _restaurantRating = 0;
  int _courierRating = 0;
  final _ratingScrollController = ScrollController();
  final _restaurantFeedbackController = TextEditingController();
  final _courierFeedbackController = TextEditingController();
  final _restaurantFeedbackFocusNode = FocusNode();
  final _courierFeedbackFocusNode = FocusNode();
  final _restaurantFeedbackKey = GlobalKey();
  final _courierFeedbackKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _restaurantFeedbackFocusNode.addListener(() {
      if (_restaurantFeedbackFocusNode.hasFocus) {
        _scrollFocusedFieldIntoView(_restaurantFeedbackKey);
      }
    });

    _courierFeedbackFocusNode.addListener(() {
      if (_courierFeedbackFocusNode.hasFocus) {
        _scrollFocusedFieldIntoView(_courierFeedbackKey);
      }
    });
  }

  void _scrollFocusedFieldIntoView(GlobalKey key) {
    Future.delayed(const Duration(milliseconds: 550), () {
      final fieldContext = key.currentContext;
      if (fieldContext == null || !fieldContext.mounted || !mounted) return;

      Scrollable.ensureVisible(
        fieldContext,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
        alignment: 0.35,
        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
      );
    });
  }

  @override
  void dispose() {
    _ratingScrollController.dispose();
    _restaurantFeedbackController.dispose();
    _courierFeedbackController.dispose();
    _restaurantFeedbackFocusNode.dispose();
    _courierFeedbackFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mediaQuery = MediaQuery.of(context);
    final bottomSafe = mediaQuery.padding.bottom;
    final keyboardBottom = mediaQuery.viewInsets.bottom;
    final isKeyboardOpen = keyboardBottom > 0;

    return KeyboardDismissOnTap(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _ratingScrollController,
              physics: const ClampingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  16,
                  20,
                  16,
                  isKeyboardOpen ? keyboardBottom + 160 : 120 + bottomSafe,
                ),
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
                      imageAsset: AppAssets.orderRestaurantAvatar,
                      name: l10n.orderRestaurantAzAlSham,
                      rating: _restaurantRating,
                      feedbackController: _restaurantFeedbackController,
                      feedbackFocusNode: _restaurantFeedbackFocusNode,
                      feedbackFieldKey: _restaurantFeedbackKey,
                      feedbackLabel: l10n.yourRating,
                      feedbackHint: l10n.ratingFeedbackHint,
                      onFeedbackTap: () =>
                          _scrollFocusedFieldIntoView(_restaurantFeedbackKey),
                      onRatingChanged: (value) =>
                          setState(() => _restaurantRating = value),
                      circularImage: true,
                    ),
                    const SizedBox(height: 16),
                    Divider(
                      height: 1,
                      thickness: 0.5,
                      color: AppColors.border(context),
                    ),
                    const SizedBox(height: 16),
                    _RatingTargetSection(
                      imageAsset: AppAssets.orderCourierAvatar,
                      name: l10n.orderCourierName,
                      rating: _courierRating,
                      feedbackController: _courierFeedbackController,
                      feedbackFocusNode: _courierFeedbackFocusNode,
                      feedbackFieldKey: _courierFeedbackKey,
                      feedbackLabel: l10n.yourRating,
                      feedbackHint: l10n.ratingFeedbackHint,
                      onFeedbackTap: () =>
                          _scrollFocusedFieldIntoView(_courierFeedbackKey),
                      onRatingChanged: (value) =>
                          setState(() => _courierRating = value),
                      circularImage: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsetsDirectional.fromSTEB(
              16,
              20,
              16,
              20 + bottomSafe,
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
                    onTap: widget.onSkip,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _PrimaryFilledButton(
                    label: l10n.submitRating,
                    onTap: widget.onSubmit,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingTargetSection extends StatelessWidget {
  const _RatingTargetSection({
    required this.imageAsset,
    required this.name,
    required this.rating,
    required this.feedbackController,
    required this.feedbackFocusNode,
    required this.feedbackFieldKey,
    required this.feedbackLabel,
    required this.feedbackHint,
    required this.onFeedbackTap,
    required this.onRatingChanged,
    required this.circularImage,
  });

  final String imageAsset;
  final String name;
  final int rating;
  final TextEditingController feedbackController;
  final FocusNode feedbackFocusNode;
  final GlobalKey feedbackFieldKey;
  final String feedbackLabel;
  final String feedbackHint;
  final VoidCallback onFeedbackTap;
  final ValueChanged<int> onRatingChanged;
  final bool circularImage;

  @override
  Widget build(BuildContext context) {
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(circularImage ? 30 : 12),
      child: imageAsset == AppAssets.orderCourierAvatar
          ? _buildCourierAvatar()
          : Image.asset(imageAsset, width: 60, height: 60, fit: BoxFit.cover),
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
        Container(
          key: feedbackFieldKey,
          child: TextField(
            controller: feedbackController,
            focusNode: feedbackFocusNode,
            minLines: 3,
            maxLines: 4,
            textAlign: TextAlign.start,
            cursorColor: AppColors.cursor(context),
            style: AppTextStyles.inputText(context).copyWith(fontSize: 12),
            onTap: onFeedbackTap,
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
                60,
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

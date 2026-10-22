import 'package:flutter/material.dart';
import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/features/order/presentation/pages/order_detail_screen.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

enum OrderNormalizedStatus {
  waitingAcceptance,
  preparing,
  courierOnWay,
  delivered,
  cancelled,
}

OrderNormalizedStatus normalizeOrderStatus(String? status) {
  switch (status?.toLowerCase()) {
    case 'pending':
      return OrderNormalizedStatus.waitingAcceptance;
    case 'confirmed':
    case 'ready_for_pickup':
      return OrderNormalizedStatus.preparing;
    case 'assigned':
    case 'on_the_way':
      return OrderNormalizedStatus.courierOnWay;
    case 'delivered':
      return OrderNormalizedStatus.delivered;
    case 'cancelled':
    case 'rejected':
    default:
      return OrderNormalizedStatus.cancelled;
  }
}

OrderDetailsStatus toOrderDetailsStatus(OrderNormalizedStatus normalized) {
  switch (normalized) {
    case OrderNormalizedStatus.waitingAcceptance:
      return OrderDetailsStatus.waitingAcceptance;
    case OrderNormalizedStatus.preparing:
      return OrderDetailsStatus.preparing;
    case OrderNormalizedStatus.courierOnWay:
      return OrderDetailsStatus.courierOnWay;
    case OrderNormalizedStatus.delivered:
      return OrderDetailsStatus.delivered;
    case OrderNormalizedStatus.cancelled:
      return OrderDetailsStatus.cancelled;
  }
}

class OrderStatusUiModel {
  final OrderNormalizedStatus normalizedStatus;
  final String shortStatusLabel;
  final String statusLabel;
  final String badgeLabel;
  final Color statusColor;
  final String statusIconAsset;
  final int? progressStep;
  final bool showEta;
  final bool isClosed;
  final bool cancelled;
  final bool showCourierSection;
  final bool showCancelAction;
  final bool showCancellationReason;
  final bool showRateAction;

  const OrderStatusUiModel({
    required this.normalizedStatus,
    required this.shortStatusLabel,
    required this.statusLabel,
    required this.badgeLabel,
    required this.statusColor,
    required this.statusIconAsset,
    required this.progressStep,
    required this.showEta,
    required this.isClosed,
    required this.cancelled,
    required this.showCourierSection,
    required this.showCancelAction,
    required this.showCancellationReason,
    required this.showRateAction,
  });

  factory OrderStatusUiModel.fromStatus({
    required String? status,
    required AppLocalizations l10n,
    bool isDetailScreen = false,
  }) {
    final normalized = normalizeOrderStatus(status);

    switch (normalized) {
      case OrderNormalizedStatus.waitingAcceptance:
        return OrderStatusUiModel(
          normalizedStatus: normalized,
          shortStatusLabel: l10n.orderWaitingAcceptanceShort,
          statusLabel: l10n.orderWaitingAcceptance,
          badgeLabel: l10n.reorder,
          statusColor: AppColors.statusWarning,
          statusIconAsset: AppAssets.orderReceiptRollIcon,
          progressStep: 0,
          showEta: true,
          isClosed: false,
          cancelled: false,
          showCourierSection: false,
          showCancelAction: true,
          showCancellationReason: false,
          showRateAction: false,
        );

      case OrderNormalizedStatus.preparing:
        return OrderStatusUiModel(
          normalizedStatus: normalized,
          shortStatusLabel: isDetailScreen
              ? l10n.orderAcceptedShort
              : l10n.orderPreparingShort,
          statusLabel: l10n.orderPreparing,
          badgeLabel: l10n.reorder,
          statusColor: isDetailScreen ? AppColors.success : AppColors.primary,
          statusIconAsset: AppAssets.orderAcceptedIcon,
          progressStep: 1,
          showEta: true,
          isClosed: false,
          cancelled: false,
          showCourierSection: false,
          showCancelAction: false,
          showCancellationReason: false,
          showRateAction: false,
        );

      case OrderNormalizedStatus.courierOnWay:
        return OrderStatusUiModel(
          normalizedStatus: normalized,
          shortStatusLabel: isDetailScreen
              ? l10n.orderHandedToCourierShort
              : l10n.orderCourierOnWayShort,
          statusLabel: l10n.orderCourierOnWay,
          badgeLabel: l10n.reorder,
          statusColor: AppColors.primary,
          statusIconAsset: AppAssets.orderCourierOnWayIcon,
          progressStep: 2,
          showEta: true,
          isClosed: false,
          cancelled: false,
          showCourierSection: true,
          showCancelAction: false,
          showCancellationReason: false,
          showRateAction: false,
        );

      case OrderNormalizedStatus.delivered:
        return OrderStatusUiModel(
          normalizedStatus: normalized,
          shortStatusLabel: l10n.orderDeliveredShort,
          statusLabel: l10n.orderDelivered,
          badgeLabel: l10n.orderDeliveredShort,
          statusColor: AppColors.statusClosed,
          statusIconAsset: AppAssets.orderDeliveredStatus,
          progressStep: null,
          showEta: false,
          isClosed: true,
          cancelled: false,
          showCourierSection: true,
          showCancelAction: false,
          showCancellationReason: false,
          showRateAction: true,
        );

      case OrderNormalizedStatus.cancelled:
        final label = status?.toLowerCase() == 'rejected'
            ? l10n.orderRejectedByStore
            : l10n.orderYouCancelled;

        return OrderStatusUiModel(
          normalizedStatus: normalized,
          shortStatusLabel: l10n.orderCancelledShort,
          statusLabel: label,
          badgeLabel: l10n.orderCancelledShort,
          statusColor: AppColors.error,
          statusIconAsset: AppAssets.orderTornReceiptIcon,
          progressStep: null,
          showEta: false,
          isClosed: true,
          cancelled: true,
          showCourierSection: false,
          showCancelAction: false,
          showCancellationReason: true,
          showRateAction: false,
        );
    }
  }
}

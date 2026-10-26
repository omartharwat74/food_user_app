import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/utils/extensions/context_ext.dart';
import 'package:food_user_app/features/order/domain/entities/order.dart';
import 'package:food_user_app/features/order/presentation/widgets/product_notes_dialog.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

class OrderItemTile extends StatelessWidget {
  const OrderItemTile({
    super.key,
    required this.item,
    required this.l10n,
  });

  final OrderItem? item;
  final AppLocalizations l10n;

  String _formatAmount(double amount) {
    if (amount == amount.truncateToDouble()) {
      return amount.toInt().toString();
    }
    return amount.toStringAsFixed(2);
  }

  bool _isSpicy() {
    if (item == null) return false;
    for (final opt in item!.selectedOptions) {
      if (opt is Map) {
        final val = opt['value_name']?.toString() ??
            opt['value']?.toString() ??
            opt['name']?.toString();
        if (val == 'حار' ||
            val?.toLowerCase() == 'hot' ||
            val?.toLowerCase() == 'spicy') {
          return true;
        }
      } else if (opt is String &&
          (opt == 'حار' ||
              opt.toLowerCase() == 'hot' ||
              opt.toLowerCase() == 'spicy')) {
        return true;
      }
    }
    return false;
  }

  String? _getSubtitle() {
    if (item == null || item!.selectedOptions.isEmpty) return null;
    final opts = <String>[];
    for (final opt in item!.selectedOptions) {
      if (opt is Map) {
        final val = opt['value_name']?.toString() ??
            opt['name']?.toString() ??
            opt['value']?.toString();
        if (val != null &&
            val.trim().isNotEmpty &&
            val != 'حار' &&
            val.toLowerCase() != 'hot' &&
            val.toLowerCase() != 'spicy') {
          opts.add(val.trim());
        }
      } else if (opt is String &&
          opt.trim().isNotEmpty &&
          opt != 'حار' &&
          opt.toLowerCase() != 'hot' &&
          opt.toLowerCase() != 'spicy') {
        opts.add(opt.trim());
      }
    }
    return opts.isNotEmpty ? opts.join(' • ') : null;
  }

  @override
  Widget build(BuildContext context) {
    final name = item?.name ?? l10n.orderProductName;
    final price = item != null
        ? context.l10n.priceWithCurrency(_formatAmount(item!.lineTotal > 0
            ? item!.lineTotal
            : (item!.unitPrice * item!.quantity)))
        : l10n.orderProductPrice;
    final quantityText = l10n.orderQuantity(item?.quantity ?? 2);
    final image = item?.image;
    final isSpicy = _isSpicy();
    final subtitle = _getSubtitle();
    final hasNotes = item?.notes != null && item!.notes!.trim().isNotEmpty;

    final productGroup = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: AppColors.surfaceCard(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border(context), width: 0.5),
          ),
          alignment: Alignment.center,
          child: image != null && image.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: image,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Image.asset(
                      AppAssets.orderProductImage,
                      width: 54,
                      height: 27,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              : Image.asset(
                  AppAssets.orderProductImage,
                  width: 54,
                  height: 27,
                  fit: BoxFit.contain,
                ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      name,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Expo Arabic',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                        color: AppColors.onSurface(context),
                      ),
                    ),
                  ),
                  if (isSpicy) ...[
                    const SizedBox(width: 8),
                    Container(
                      height: 20,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.errorTint,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppAssets.orderSpicyChiliIcon,
                            width: 12,
                            height: 12.5,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            context.l10n.productFlavorHot,
                            style: const TextStyle(
                              fontFamily: 'Expo Arabic',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              height: 15.6 / 12.0,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              Text(
                price,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Expo Arabic',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 15.6 / 12.0,
                  color: AppColors.onSurface(context),
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Expo Arabic',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.paragraph(context)
                        : const Color(0xFF787878),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: productGroup),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              quantityText,
              style: TextStyle(
                fontFamily: 'Expo Arabic',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 15.6 / 12.0,
                color: AppColors.paragraph(context),
              ),
            ),
            if (hasNotes) ...[
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => ProductNotesDialog.show(context, item!.notes!),
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      l10n.productYourNotes,
                      style: TextStyle(
                        fontFamily: 'Expo Arabic',
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        height: 12.5 / 10.0,
                        color: AppColors.onSurface(context),
                      ),
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.asset(
                      AppAssets.orderNoteEditIcon,
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

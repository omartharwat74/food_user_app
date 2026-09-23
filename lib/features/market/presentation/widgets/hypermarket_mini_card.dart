import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/delivery_time_text.dart';
import 'package:food_user_app/features/restaurant/domain/entities/restaurant.dart';

class HypermarketMiniCard extends StatelessWidget {
  final Restaurant market;
  final VoidCallback onTap;

  const HypermarketMiniCard({
    super.key,
    required this.market,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          // was hardcoded Colors.white — now theme-aware
          color: AppColors.surfaceCard(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border(context), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.08),
              blurRadius: 4,
              offset: Offset.zero,
            ),
          ],
        ),
        child: SizedBox(
          width: 76,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2,
                    color: AppColors.border(context),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: market.logoUrl.isNotEmpty
                    ? Image.network(
                        market.logoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Icon(
                          Icons.store,
                          color: AppColors.paragraph(context),
                          size: 20,
                        ),
                      )
                    : Icon(
                        Icons.store,
                        color: AppColors.paragraph(context),
                        size: 20,
                      ),
              ),
              const SizedBox(height: 8),

              // Market name
              Text(
                market.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body(context).copyWith(
                  // was hardcoded Colors.black
                  color: AppColors.onSurface(context),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.30,
                ),
              ),
              const SizedBox(height: 4),

              // Delivery time row
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time,
                    size: 12,
                    color: AppColors.paragraph(context),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: DeliveryTimeText(
                      minTime: market.deliveryTimeMin,
                      maxTime: market.deliveryTimeMax,
                      style: AppTextStyles.caption(context).copyWith(
                        color: AppColors.paragraph(context),
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        height: 1.25,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

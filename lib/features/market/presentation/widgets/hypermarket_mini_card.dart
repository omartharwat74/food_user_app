import 'package:flutter/material.dart';
import 'package:food_user_app/core/widgets/delivery_time_text.dart';
import 'package:food_user_app/features/restaurant/domain/entities/restaurant.dart';

class HypermarketMiniCard extends StatelessWidget {
  final Restaurant market;
  final VoidCallback onTap;

  const HypermarketMiniCard({super.key, required this.market, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x142C2A2A),
              blurRadius: 4,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        child: SizedBox(
          width: 76,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Logo Container (40x40 with white border)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2,
                    color: Colors.white,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: (market.logoUrl.isNotEmpty)
                    ? Image.network(
                        market.logoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const Icon(Icons.store, color: Colors.grey, size: 20),
                      )
                    : const Icon(Icons.store, color: Colors.grey, size: 20),
              ),
              const SizedBox(height: 8),
              
              // 2. Market Name
              Text(
                market.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Expo Arabic',
                  fontWeight: FontWeight.w500,
                  height: 1.30,
                ),
              ),
              const SizedBox(height: 4),
              
              // 3. Delivery Time & Icon
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.access_time, size: 12, color: Color(0xFF787878)),
                  const SizedBox(width: 4),
                  Flexible(
                    child: DeliveryTimeText(
                      minTime: market.deliveryTimeMin,
                      maxTime: market.deliveryTimeMax,
                      style: const TextStyle(
                        color: Color(0xFF787878),
                        fontSize: 10,
                        fontFamily: 'Expo Arabic',
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

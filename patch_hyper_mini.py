with open('lib/features/market/presentation/widgets/hypermarket_mini_card.dart', 'r') as f:
    content = f.read()

old = """                  Flexible(
                    child: Text(
                      '${market.deliveryTimeMin}-${market.deliveryTimeMax} دقيقة',
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF787878),
                        fontSize: 10,
                        fontFamily: 'Expo Arabic',
                        fontWeight: FontWeight.w400,
                        height: 1.25,
                      ),
                    ),
                  ),"""

new = """                  Flexible(
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
                  ),"""

content = content.replace(old, new)
with open('lib/features/market/presentation/widgets/hypermarket_mini_card.dart', 'w') as f:
    f.write(content)

with open('lib/features/market/presentation/widgets/market_card.dart', 'r') as f:
    content = f.read()

old = """                          Text(
                            isArabic
                                ? '${market.deliveryTimeMin}-${market.deliveryTimeMax} دقيقة'
                                : '${market.deliveryTimeMin}-${market.deliveryTimeMax} min',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.hintColor,
                            ),
                          ),"""

new = """                          DeliveryTimeText(
                            minTime: market.deliveryTimeMin,
                            maxTime: market.deliveryTimeMax,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.hintColor,
                            ),
                          ),"""

content = content.replace(old, new)
with open('lib/features/market/presentation/widgets/market_card.dart', 'w') as f:
    f.write(content)

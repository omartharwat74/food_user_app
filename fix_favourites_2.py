with open('lib/features/profile/presentation/pages/favourites_screen.dart', 'r') as f:
    content = f.read()

old_class = """class _DeliveryTimeLabel extends StatelessWidget {
  const _DeliveryTimeLabel({required this.deliveryTime});

  final String deliveryTime;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final icon = SvgPicture.asset(
      AppAssets.favoriteTimeIcon,
      width: FavouritesScreen._metaIconSize,
      height: FavouritesScreen._metaIconSize,
      colorFilter: const ColorFilter.mode(Color(0xFF6B7280), BlendMode.srcIn),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: FavouritesScreen._metaSpacing),
        Text(
          deliveryTime,
          style: AppTextStyles.caption(context).copyWith(
            fontSize: FavouritesScreen._metaFontSize,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}"""

new_class = """class _DeliveryTimeLabel extends StatelessWidget {
  const _DeliveryTimeLabel({required this.minTime, required this.maxTime});

  final int minTime;
  final int maxTime;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final icon = SvgPicture.asset(
      AppAssets.favoriteTimeIcon,
      width: FavouritesScreen._metaIconSize,
      height: FavouritesScreen._metaIconSize,
      colorFilter: const ColorFilter.mode(Color(0xFF6B7280), BlendMode.srcIn),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: FavouritesScreen._metaSpacing),
        DeliveryTimeText(
          minTime: minTime,
          maxTime: maxTime,
          style: AppTextStyles.caption(context).copyWith(
            fontSize: FavouritesScreen._metaFontSize,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}"""

# I need to use regex since spacing might differ
import re
content = re.sub(r'class _DeliveryTimeLabel extends StatelessWidget \{[\s\S]*?\}\n\}', new_class, content)

with open('lib/features/profile/presentation/pages/favourites_screen.dart', 'w') as f:
    f.write(content)

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/utils/extensions/context_ext.dart';
import 'package:food_user_app/features/home/domain/entities/banner.dart';

class PromoBannerCard extends StatelessWidget {
  final BannerItem banner;
  final VoidCallback? onTap;
  final bool isHome;

  const PromoBannerCard({
    super.key,
    required this.banner,
    this.onTap,
    this.isHome = false,
  });

  /// Normalizes whitespace and preserves natural wrapping.
  String _formatTitle(String raw) {
    final clean = raw.trim();
    if (clean.isEmpty) return clean;
    return clean.split(RegExp(r'\r?\n|\u2028')).map((l) => l.trim()).join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final title = banner.title?.trim() ?? '';
    final subtitle = banner.subtitle.trim();
    final imageUrl = banner.imageUrl?.trim() ?? '';

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bannerWidth = constraints.maxWidth;
            final leftOffset = bannerWidth * 0.085;
            final imageWidth = isHome ? 122.0 : 110.0;
            final imageHeight = isHome ? 102.0 : 92.0;

            return Stack(
              fit: StackFit.expand,
              children: [
                // Mirrored background in English (LTR), normal in Arabic (RTL)
                Positioned.fill(
                  child: Transform.flip(
                    flipX: !isRtl,
                    child: Image.asset(
                      AppAssets.promoBannerBg,
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),

                // Image side: Positioned with left = constraints.maxWidth * 0.06 in RTL
                Positioned(
                  left: isRtl ? leftOffset : null,
                  right: !isRtl ? leftOffset : null,
                  top: 0,
                  bottom: 0,
                  width: imageWidth,
                  child: Center(
                    child: SizedBox(
                      width: imageWidth,
                      height: imageHeight,
                      child: imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              width: imageWidth,
                              height: imageHeight,
                              fit: BoxFit.contain,
                              errorWidget: (context, url, error) => Image.asset(
                                AppAssets.homeOfferProduct,
                                width: imageWidth,
                                height: imageHeight,
                                fit: BoxFit.contain,
                              ),
                            )
                          : Image.asset(
                              AppAssets.homeOfferProduct,
                              width: imageWidth,
                              height: imageHeight,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                ),

                // Content text side (Red side)
                PositionedDirectional(
                  start: 0,
                  top: 0,
                  bottom: 0,
                  end: leftOffset + imageWidth,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      18,
                      21,
                      6,
                      21,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (title.isNotEmpty)
                                Text(
                                  title,
                                  textAlign: isRtl ? TextAlign.right : TextAlign.left,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isHome ? 14 : 13,
                                    fontFamily: 'ExpoArabic',
                                    fontFamilyFallback: const ['Expo Arabic'],
                                    fontWeight: FontWeight.w500,
                                    height: 1.25,
                                  ),
                                ),
                              if (subtitle.isNotEmpty) ...[
                                if (title.isNotEmpty) const SizedBox(height: 4),
                                SizedBox(
                                  width: isHome ? 120 : null,
                                  child: Text(
                                    _formatTitle(subtitle),
                                    textAlign: isRtl ? TextAlign.right : TextAlign.left,
                                    maxLines: isHome ? 3 : 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isHome ? 15 : 14,
                                      fontFamily: 'ExpoArabic',
                                      fontFamilyFallback: const ['Expo Arabic'],
                                      fontWeight: FontWeight.w600,
                                      height: 1.25,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: isRtl
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                context.l10n.homeOrderNow,
                                textAlign: isRtl ? TextAlign.right : TextAlign.left,
                                style: TextStyle(
                                  color: const Color(0xFFEFBD1B),
                                  fontSize: isHome ? 15 : 14,
                                  fontFamily: 'ExpoArabic',
                                  fontFamilyFallback: const ['Expo Arabic'],
                                  fontWeight: FontWeight.w600,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Transform.flip(
                                flipX: !isRtl,
                                child: SvgPicture.asset(
                                  AppAssets.bannerArrow,
                                  width: 18,
                                  height: 18,
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFFEFBD1B),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

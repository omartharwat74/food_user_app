import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/utils/extensions/context_ext.dart';
import 'package:food_user_app/features/home/domain/entities/banner.dart';

class PromoBannerCard extends StatelessWidget {
  final BannerItem banner;
  final VoidCallback? onTap;

  const PromoBannerCard({
    super.key,
    required this.banner,
    this.onTap,
  });

  /// Ensures line 1 has at most 3 words, and the rest wrap to the next line.
  String _formatTitle(String raw) {
    final clean = raw.trim();
    if (clean.isEmpty) return clean;

    final lines = clean.split(RegExp(r'\r?\n|\u2028'));
    final firstLineWords = lines.first.trim().split(RegExp(r'\s+'));

    if (firstLineWords.length <= 3) {
      return clean;
    }

    final line1 = firstLineWords.sublist(0, 3).join(' ');
    final remainingLine1 = firstLineWords.sublist(3).join(' ');
    final rest = [
      remainingLine1,
      ...lines.skip(1),
    ].where((s) => s.isNotEmpty).join(' ');

    return '$line1\n$rest';
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final title = banner.title?.trim() ?? '';
    final imageUrl = banner.imageUrl?.trim() ?? '';

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AspectRatio(
          aspectRatio: 343 / 117,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bannerWidth = constraints.maxWidth;
              final leftOffset = bannerWidth * 0.085;
              const imageWidth = 110.0;
              const imageHeight = 92.0;

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

                  // Image side: Positioned with left = constraints.maxWidth * 0.085 in RTL
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
                      padding: const EdgeInsetsDirectional.fromSTEB(18, 21, 6, 21),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  context.l10n.specialOffer,
                                  textAlign: isRtl ? TextAlign.right : TextAlign.left,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontFamily: 'ExpoArabic',
                                    fontFamilyFallback: ['Expo Arabic'],
                                    fontWeight: FontWeight.w500,
                                    height: 1.25,
                                  ),
                                ),
                                if (title.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    _formatTitle(title),
                                    textAlign: isRtl ? TextAlign.right : TextAlign.left,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'ExpoArabic',
                                      fontFamilyFallback: ['Expo Arabic'],
                                      fontWeight: FontWeight.w400,
                                      height: 1.25,
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
                                  style: const TextStyle(
                                    color: Color(0xFFEFBD1B),
                                    fontSize: 14,
                                    fontFamily: 'ExpoArabic',
                                    fontFamilyFallback: ['Expo Arabic'],
                                    fontWeight: FontWeight.w500,
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
      ),
    );
  }
}

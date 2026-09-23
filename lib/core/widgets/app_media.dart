import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_user_app/core/theme/app_colors.dart';

/// Local SVG from the asset bundle with a loading placeholder.
class AppSvgImage extends StatelessWidget {
  const AppSvgImage.asset(
    this.assetName, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.semanticsLabel,
    this.color,
  });

  final String assetName;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String? semanticsLabel;

  /// When set, replaces solid fills in the SVG (e.g. white icon on primary button).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      fit: fit,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      semanticsLabel: semanticsLabel,
      placeholderBuilder: (context) => SizedBox(
        width: width ?? 24,
        height: height ?? 24,
        child: Icon(
          Icons.image_outlined,
          size: 20,
          color: AppColors.hint(context),
        ),
      ),
    );
  }
}

/// Raster image from the asset bundle.
class AppRasterImage extends StatelessWidget {
  const AppRasterImage.asset(
    this.assetName, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.colorBlendMode,
  });

  final String assetName;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final BlendMode? colorBlendMode;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetName,
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      errorBuilder: (context, error, stackTrace) {
        developer.log(
          'AppRasterImage failed to load asset path=$assetName error=$error',
          name: 'AppRasterImage',
          error: error,
          stackTrace: stackTrace,
        );
        return Container(
          width: width,
          height: height,
          color: AppColors.surfaceCard(context),
          alignment: Alignment.center,
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 20,
            color: AppColors.hint(context),
          ),
        );
      },
    );
  }
}

/// Network image with logging when decoding fails (e.g. HTML/JSON error pages).
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return SizedBox(
        width: width,
        height: height,
        child: Icon(Icons.storefront, color: AppColors.paragraph(context)),
      );
    }

    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        developer.log(
          'AppNetworkImage: response was not a decodable image '
          '(often HTML, JSON, 403/404, or expired signed URL). url=$url',
          name: 'AppNetworkImage',
          error: error,
          stackTrace: stackTrace,
        );
        return SizedBox(
          width: width,
          height: height,
          child: Icon(
            Icons.broken_image_outlined,
            color: AppColors.paragraph(context),
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
          width: width,
          height: height,
          child: Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.paragraph(context),
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}

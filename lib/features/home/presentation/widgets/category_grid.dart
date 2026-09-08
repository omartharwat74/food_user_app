import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/app_spacing.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/app_media.dart';
import 'package:food_user_app/features/home/domain/entities/section.dart';
import 'package:food_user_app/features/home/presentation/cubit/home_cubits.dart';
import 'package:food_user_app/features/service_listing/presentation/models/service_listing_type.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SectionsCubit, SectionsState>(
      builder: (context, state) {
        if (state is SectionsLoaded) {
          final sections = state.sections;
          if (sections.isEmpty) return const SizedBox.shrink();

          return Row(
            children: [
              for (var index = 0; index < sections.length; index++) ...[
                Expanded(child: _CategoryTile(section: sections[index])),
                if (index != sections.length - 1)
                  const SizedBox(width: 14),
              ],
            ],
          );
        }
        
        return const SizedBox(
          height: 104,
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.section});

  final Section section;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Map section to legacy service listing type for now if needed,
        // or just navigate to generic store listing
        // Assuming ID 1 = restaurants, ID 2 = grocery etc. based on old logic
        final type = _getLegacyType(section);
        context.push(RouteNames.serviceListingFor(type.pathSegment, section.id));
      },
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.surfaceCard(context),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              border: Border.all(color: AppColors.border(context), width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const PositionedDirectional(
                  top: 0,
                  start: 0,
                  end: 0,
                  child: AppRasterImage.asset(
                    AppAssets.homeCategoryStrokeTop,
                    height: 2,
                    fit: BoxFit.fill,
                  ),
                ),
                const PositionedDirectional(
                  bottom: 0,
                  start: 0,
                  end: 0,
                  child: AppRasterImage.asset(
                    AppAssets.homeCategoryStrokeBottom,
                    height: 2,
                    fit: BoxFit.fill,
                  ),
                ),
                if (section.image != null)
                  AppNetworkImage(
                    section.image!,
                    width: 56,
                    height: 56,
                  )
                else
                  const Icon(Icons.storefront, size: 30, color: Colors.grey),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            section.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body(context).copyWith(
              fontSize: 12,
              height: 1.3,
              color: AppColors.onSurface(context),
            ),
          ),
        ],
      ),
    );
  }

  ServiceListingType _getLegacyType(Section section) {
    if (section.id == 1 || section.name.contains('مطاعم') || section.name.toLowerCase().contains('restaurant')) return ServiceListingType.restaurants;
    if (section.id == 2 || section.name.contains('بقالة') || section.name.toLowerCase().contains('grocery')) return ServiceListingType.grocery;
    if (section.id == 3 || section.name.contains('متاجر') || section.name.toLowerCase().contains('store')) return ServiceListingType.stores;
    if (section.id == 4 || section.name.contains('توصيل') || section.name.toLowerCase().contains('pickup')) return ServiceListingType.pickup;
    return ServiceListingType.restaurants;
  }
}

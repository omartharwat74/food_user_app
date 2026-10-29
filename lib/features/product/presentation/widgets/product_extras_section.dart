import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/utils/extensions/context_ext.dart';
import 'package:food_user_app/core/utils/price_extension.dart';
import 'package:food_user_app/core/widgets/top_snackbar.dart';
import 'package:food_user_app/features/cart/domain/entities/cart_extra_item.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_extras_cubit.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_extras_state.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

class ProductExtrasSection extends StatelessWidget {
  const ProductExtrasSection({super.key});

  @override
  Widget build(BuildContext context) {
    CartExtrasCubit? cubit;
    try {
      cubit = context.read<CartExtrasCubit>();
    } catch (_) {}

    if (cubit == null) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<CartExtrasCubit, CartExtrasState>(
      builder: (context, state) {
        if (state.items.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsetsDirectional.only(top: 20),
          width: double.infinity,
          padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 20),
          color: AppColors.surfaceCard(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.productAddSomethingTitle,
                textAlign: TextAlign.start,
                style: AppTextStyles.heading4(context).copyWith(
                  color: AppColors.onSurface(context),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.productAddSomethingSubtitle,
                textAlign: TextAlign.start,
                style: AppTextStyles.caption(context).copyWith(
                  color: AppColors.paragraph(context),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 172,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.items.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return _ProductExtraCard(
                      item: item,
                      isAdding: state.addingProductId == item.id,
                      isAnyAdding: state.addingProductId != null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProductExtraCard extends StatelessWidget {
  const _ProductExtraCard({
    required this.item,
    required this.isAdding,
    required this.isAnyAdding,
  });

  final CartExtraItem item;
  final bool isAdding;
  final bool isAnyAdding;

  void _onAdd(BuildContext context) {
    if (isAnyAdding) return;

    context.read<CartExtrasCubit>().addExtra(
      item: item,
      onSuccess: () {
        showTopSnackBar(
          context,
          AppLocalizations.of(context)!.productAddedSuccessfully,
          isError: false,
          backgroundColor: AppColors.success,
        );
        try {
          context.read<CartCubit>().loadCart();
        } catch (_) {}
      },
      onError: (message) {
        showTopSnackBar(context, message, isError: true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final image = item.mainImage?.trim() ?? '';

    return Container(
      width: 134,
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border(context), width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: isDark
                        ? const Color(0xFF1E1E1E)
                        : const Color(0xFFF9F9F9),
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: image.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: image,
                              fit: BoxFit.contain,
                              errorWidget: (_, _, _) => Image.asset(
                                AppAssets.productAddonToast,
                                fit: BoxFit.contain,
                              ),
                            )
                          : Image.asset(
                              AppAssets.productAddonToast,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                ),
                PositionedDirectional(
                  end: 8,
                  bottom: 8,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: isAnyAdding ? null : () => _onAdd(context),
                    child: Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceCard(context),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: isAdding
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            )
                          : SvgPicture.asset(
                              AppAssets.cartPlusIcon,
                              width: 18,
                              height: 18,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 0.5,
            color: AppColors.border(context),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 8, 10, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption(context).copyWith(
                    color: AppColors.onSurface(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.priceWithCurrency(
                        item.priceAfterDiscount.toFormattedPrice(),
                      ),
                      style: AppTextStyles.textLink(context).copyWith(
                        color: AppColors.onSurface(context),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                    if (item.hasDiscount)
                      Text(
                        AppLocalizations.of(context)!.priceWithCurrency(
                          item.basePrice.toFormattedPrice(),
                        ),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.lineThrough,
                          color: AppColors.paragraph(context),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

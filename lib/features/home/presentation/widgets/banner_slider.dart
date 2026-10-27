import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/app_spacing.dart';
import 'package:food_user_app/core/widgets/promo_banner_card.dart';
import 'package:food_user_app/features/home/presentation/cubit/banner_cubit.dart';
import 'package:food_user_app/features/home/presentation/cubit/banner_state.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  late final PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerCubit, BannerState>(
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (banners) {
            if (banners.isEmpty) return const SizedBox.shrink();

            return Column(
              children: [
                SizedBox(
                  height: 150,
                  child: PageView.builder(
                    controller: _controller,
                    onPageChanged: (page) =>
                        setState(() => _currentPage = page),
                    itemCount: banners.length,
                    itemBuilder: (context, index) {
                      final banner = banners[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        child: PromoBannerCard(
                          banner: banner,
                          isHome: true,
                          onTap: () async {
                            if (banner.type == 'store' ||
                                (banner.storeId != null &&
                                    banner.storeId! > 0)) {
                              if (banner.storeId != null &&
                                  banner.storeId! > 0) {
                                context.push(
                                  RouteNames.restaurantDetailFor(
                                    banner.storeId.toString(),
                                  ),
                                );
                              }
                            } else if (banner.type == 'link' ||
                                (banner.link != null &&
                                    banner.link!.isNotEmpty)) {
                              if (banner.link != null &&
                                  banner.link!.isNotEmpty) {
                                final uri = Uri.tryParse(banner.link!);
                                if (uri != null && await canLaunchUrl(uri)) {
                                  await launchUrl(
                                    uri,
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              }
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                _BannerIndicator(
                  activePage: _currentPage,
                  count: banners.length,
                ),
              ],
            );
          },
          orElse: () {
            return const SizedBox(
              height: 150,
              child: Center(child: CircularProgressIndicator()),
            );
          },
        );
      },
    );
  }
}

class _BannerIndicator extends StatelessWidget {
  const _BannerIndicator({required this.activePage, required this.count});

  final int activePage;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == activePage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.border(context),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

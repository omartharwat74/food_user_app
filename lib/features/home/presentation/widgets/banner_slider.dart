import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/app_spacing.dart';
import 'package:food_user_app/core/widgets/app_media.dart';
import 'package:food_user_app/features/home/domain/entities/banner.dart';
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
                  height: 155,
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
                        child: _PromoBanner(banner: banner),
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
              height: 155,
              child: Center(child: CircularProgressIndicator()),
            );
          },
        );
      },
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner({required this.banner});

  final BannerItem banner;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppNetworkImage(
            banner.imageUrl ?? '',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ],
      ),
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

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/home/domain/repositories/banner_repository.dart';
import 'banner_state.dart';

class BannerCubit extends Cubit<BannerState> {
  final BannerRepository bannerRepository;

  BannerCubit({required this.bannerRepository})
    : super(const BannerState.initial());

  Future<void> getActiveBanners() async {
    emit(const BannerState.loading());
    final result = await bannerRepository.getActiveBanners();
    if (isClosed) return;
    result.fold(
      (failure) => emit(BannerState.error(failure.message)),
      (banners) => emit(BannerState.loaded(banners)),
    );
  }
}

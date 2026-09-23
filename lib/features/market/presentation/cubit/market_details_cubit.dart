import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/market_category.dart';
import '../../domain/entities/market_offer.dart';
import '../../domain/usecases/get_market_categories_usecase.dart';
import '../../domain/usecases/get_market_detail_usecase.dart';
import '../../domain/usecases/get_market_offers_usecase.dart';
import 'market_details_state.dart';

class MarketDetailsCubit extends Cubit<MarketDetailsState> {
  final GetMarketDetailUseCase _getMarketDetailUseCase;
  final GetMarketCategoriesUseCase _getMarketCategoriesUseCase;
  final GetMarketOffersUseCase _getMarketOffersUseCase;

  MarketDetailsCubit({
    required GetMarketDetailUseCase getMarketDetailUseCase,
    required GetMarketCategoriesUseCase getMarketCategoriesUseCase,
    required GetMarketOffersUseCase getMarketOffersUseCase,
  }) : _getMarketDetailUseCase = getMarketDetailUseCase,
       _getMarketCategoriesUseCase = getMarketCategoriesUseCase,
       _getMarketOffersUseCase = getMarketOffersUseCase,
       super(const MarketDetailsInitial());

  Future<void> loadMarketDetails(String marketId) async {
    emit(const MarketDetailsLoading());

    final detailResult = await _getMarketDetailUseCase(marketId);

    if (isClosed) return;

    await detailResult.fold(
      (failure) async {
        if (isClosed) return;
        final msg = failure.message.toLowerCase();
        if (msg.contains('404') || msg.contains('not found')) {
          emit(const MarketDetailsNotFound());
        } else {
          emit(MarketDetailsError(failure.message));
        }
      },
      (market) async {
        if (isClosed) return;
        final categoriesFuture = _getMarketCategoriesUseCase(marketId);
        final offersFuture = _getMarketOffersUseCase(marketId);

        final results = await Future.wait([categoriesFuture, offersFuture]);

        if (isClosed) return;

        final categoriesResult = results[0];
        final offersResult = results[1];

        List<MarketCategory> categories = [];
        categoriesResult.fold(
          (f) => null,
          (catList) => categories = catList as List<MarketCategory>,
        );

        List<MarketOffer> offers = [];
        offersResult.fold(
          (f) => null,
          (offList) => offers = offList as List<MarketOffer>,
        );

        emit(
          MarketDetailsLoaded(
            market: market,
            categories: categories,
            offers: offers,
          ),
        );
      },
    );
  }
}

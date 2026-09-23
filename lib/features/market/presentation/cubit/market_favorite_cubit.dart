import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/market.dart';
import '../../domain/usecases/get_favorite_markets_usecase.dart';
import '../../domain/usecases/toggle_favorite_market_usecase.dart';
import 'market_favorite_state.dart';

class MarketFavoriteCubit extends Cubit<MarketFavoriteState> {
  final GetFavoriteMarketsUseCase _getFavoriteMarketsUseCase;
  final ToggleFavoriteMarketUseCase _toggleFavoriteMarketUseCase;

  MarketFavoriteCubit({
    required GetFavoriteMarketsUseCase getFavoriteMarketsUseCase,
    required ToggleFavoriteMarketUseCase toggleFavoriteMarketUseCase,
  }) : _getFavoriteMarketsUseCase = getFavoriteMarketsUseCase,
       _toggleFavoriteMarketUseCase = toggleFavoriteMarketUseCase,
       super(const MarketFavoriteInitial());

  // In-memory cache of market favorite statuses
  final Map<String, bool> _favoriteMap = {};

  bool isFavorite(String marketId, {bool fallback = false}) {
    return _favoriteMap[marketId] ?? fallback;
  }

  Future<void> fetchFavoriteMarkets() async {
    emit(const MarketFavoriteLoading());

    final result = await _getFavoriteMarketsUseCase(const NoParams());

    if (isClosed) return;

    result.fold(
      (failure) {
        if (failure is UnauthorizedFailure) {
          emit(const MarketFavoriteAuthRequired());
        } else {
          emit(MarketFavoriteError(failure.message));
        }
      },
      (markets) {
        for (final m in markets) {
          _favoriteMap[m.id] = true;
        }
        emit(
          MarketFavoriteLoaded(
            favoriteMarkets: markets,
            favoriteMap: Map.unmodifiable(_favoriteMap),
          ),
        );
      },
    );
  }

  Future<bool> toggleFavorite({
    required String marketId,
    required bool currentFavoriteStatus,
  }) async {
    // 1. Determine optimistic new status
    final initialStatus = _favoriteMap[marketId] ?? currentFavoriteStatus;
    final optimisticStatus = !initialStatus;

    // 2. Optimistic update
    _favoriteMap[marketId] = optimisticStatus;

    final currentState = state;
    if (currentState is MarketFavoriteLoaded) {
      final updatedList = List<Market>.from(currentState.favoriteMarkets);
      if (!optimisticStatus) {
        updatedList.removeWhere((m) => m.id == marketId);
      }
      emit(
        currentState.copyWith(
          favoriteMarkets: updatedList,
          favoriteMap: Map.from(_favoriteMap),
        ),
      );
    } else {
      emit(
        MarketFavoriteLoaded(
          favoriteMarkets: const [],
          favoriteMap: Map.from(_favoriteMap),
        ),
      );
    }

    // 3. Server call
    final result = await _toggleFavoriteMarketUseCase(marketId);

    if (isClosed) return optimisticStatus;

    return result.fold(
      (failure) {
        // Revert optimistic update
        _favoriteMap[marketId] = initialStatus;
        if (!isClosed && state is MarketFavoriteLoaded) {
          emit(
            (state as MarketFavoriteLoaded).copyWith(
              favoriteMap: Map.from(_favoriteMap),
            ),
          );
        }
        if (!isClosed && failure is UnauthorizedFailure) {
          emit(const MarketFavoriteAuthRequired());
        }
        return initialStatus;
      },
      (reconciledStatus) {
        // Reconcile with actual server response
        _favoriteMap[marketId] = reconciledStatus;
        if (!isClosed && state is MarketFavoriteLoaded) {
          emit(
            (state as MarketFavoriteLoaded).copyWith(
              favoriteMap: Map.from(_favoriteMap),
            ),
          );
        }
        return reconciledStatus;
      },
    );
  }
}

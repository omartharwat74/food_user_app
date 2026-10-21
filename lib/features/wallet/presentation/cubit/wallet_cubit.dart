import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/wallet/domain/entities/wallet_data.dart';
import 'package:food_user_app/features/wallet/domain/usecases/get_wallet_usecase.dart';
import 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final GetWalletUseCase _getWalletUseCase;

  WalletCubit(this._getWalletUseCase) : super(const WalletState());

  Future<void> loadWallet({int perPage = 10}) async {
    emit(state.copyWith(status: WalletStatus.loading, errorMessage: null));

    final result = await _getWalletUseCase(
      GetWalletParams(perPage: perPage, page: 1),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: WalletStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (walletData) {
        emit(
          state.copyWith(
            status: WalletStatus.loaded,
            walletData: walletData,
            hasReachedMax: walletData.currentPage >= walletData.lastPage,
          ),
        );
      },
    );
  }

  Future<void> refreshWallet({int perPage = 10}) async {
    final result = await _getWalletUseCase(
      GetWalletParams(perPage: perPage, page: 1),
    );

    result.fold(
      (failure) {
        // Keep current state on pull-to-refresh failure
      },
      (walletData) {
        emit(
          state.copyWith(
            status: WalletStatus.loaded,
            walletData: walletData,
            hasReachedMax: walletData.currentPage >= walletData.lastPage,
          ),
        );
      },
    );
  }

  Future<void> loadMoreTransactions({int perPage = 10}) async {
    if (state.isLoadingMore || state.hasReachedMax || !state.isLoaded) return;

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.walletData.currentPage + 1;
    final result = await _getWalletUseCase(
      GetWalletParams(perPage: perPage, page: nextPage),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoadingMore: false));
      },
      (newData) {
        final mergedItems = List<WalletTransaction>.from(state.walletData.items)
          ..addAll(newData.items);

        final updatedWalletData = state.walletData.copyWith(
          balance: newData.balance,
          currency: newData.currency,
          items: mergedItems,
          currentPage: newData.currentPage,
          lastPage: newData.lastPage,
          total: newData.total,
        );

        emit(
          state.copyWith(
            isLoadingMore: false,
            walletData: updatedWalletData,
            hasReachedMax: newData.currentPage >= newData.lastPage,
          ),
        );
      },
    );
  }
}

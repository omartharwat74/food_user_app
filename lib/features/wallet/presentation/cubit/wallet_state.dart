import 'package:equatable/equatable.dart';
import 'package:food_user_app/features/wallet/domain/entities/wallet_data.dart';

enum WalletStatus { initial, loading, loaded, error }

class WalletState extends Equatable {
  final WalletStatus status;
  final WalletData walletData;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final String? errorMessage;

  const WalletState({
    this.status = WalletStatus.initial,
    this.walletData = const WalletData.empty(),
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.errorMessage,
  });

  bool get isInitial => status == WalletStatus.initial;
  bool get isLoading => status == WalletStatus.loading;
  bool get isLoaded => status == WalletStatus.loaded;
  bool get isError => status == WalletStatus.error;

  WalletState copyWith({
    WalletStatus? status,
    WalletData? walletData,
    bool? isLoadingMore,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return WalletState(
      status: status ?? this.status,
      walletData: walletData ?? this.walletData,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        walletData,
        isLoadingMore,
        hasReachedMax,
        errorMessage,
      ];
}

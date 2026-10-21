import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/usecases/usecase.dart';
import 'package:food_user_app/features/wallet/domain/entities/wallet_data.dart';
import 'package:food_user_app/features/wallet/domain/repositories/wallet_repository.dart';

class GetWalletParams extends Equatable {
  final int perPage;
  final int page;

  const GetWalletParams({this.perPage = 10, this.page = 1});

  @override
  List<Object?> get props => [perPage, page];
}

class GetWalletUseCase extends UseCase<WalletData, GetWalletParams> {
  final WalletRepository repository;

  GetWalletUseCase(this.repository);

  @override
  Future<Either<Failure, WalletData>> call(GetWalletParams params) {
    return repository.getWallet(
      perPage: params.perPage,
      page: params.page,
    );
  }
}

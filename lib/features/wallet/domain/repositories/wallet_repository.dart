import 'package:dartz/dartz.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/features/wallet/domain/entities/wallet_data.dart';

abstract class WalletRepository {
  Future<Either<Failure, WalletData>> getWallet({
    int perPage = 10,
    int page = 1,
  });
}

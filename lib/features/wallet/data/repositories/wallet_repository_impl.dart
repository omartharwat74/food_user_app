import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/features/wallet/data/datasources/wallet_remote_data_source.dart';
import 'package:food_user_app/features/wallet/domain/entities/wallet_data.dart';
import 'package:food_user_app/features/wallet/domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;

  WalletRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, WalletData>> getWallet({
    int perPage = 10,
    int page = 1,
  }) async {
    try {
      final dto = await remoteDataSource.getWallet(
        perPage: perPage,
        page: page,
      );
      return Right(dto.toEntity());
    } on DioException catch (e) {
      String errorMessage = 'حدث خطأ في الاتصال بالخادم';
      final resData = e.response?.data;
      if (resData is Map<String, dynamic>) {
        errorMessage = (resData['msg'] ?? resData['message'] ?? errorMessage)
            .toString();
      } else if (e.message != null && e.message!.isNotEmpty) {
        errorMessage = e.message!;
      }
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

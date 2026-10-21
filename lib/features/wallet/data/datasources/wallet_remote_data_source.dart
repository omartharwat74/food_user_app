import 'package:food_user_app/core/constants/api_endpoints.dart';
import 'package:food_user_app/core/network/dio_client.dart';
import 'package:food_user_app/features/wallet/data/models/wallet_dto.dart';

abstract class WalletRemoteDataSource {
  Future<WalletDto> getWallet({int perPage = 10, int page = 1});
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final DioClient _dioClient;

  WalletRemoteDataSourceImpl(this._dioClient);

  @override
  Future<WalletDto> getWallet({int perPage = 10, int page = 1}) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.wallet,
      queryParameters: {
        'per_page': perPage,
        'page': page,
      },
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      return WalletDto.fromJson(data);
    }
    throw Exception('Invalid wallet response format');
  }
}

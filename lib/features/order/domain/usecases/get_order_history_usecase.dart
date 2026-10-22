import 'package:dartz/dartz.dart' hide Order;
import 'package:equatable/equatable.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/usecases/usecase.dart';
import 'package:food_user_app/features/order/domain/entities/orders_paginated_data.dart';
import 'package:food_user_app/features/order/domain/repositories/order_repository.dart';

class GetOrderHistoryParams extends Equatable {
  final int perPage;
  final int page;

  const GetOrderHistoryParams({this.perPage = 10, this.page = 1});

  @override
  List<Object?> get props => [perPage, page];
}

class GetOrderHistoryUseCase
    extends UseCase<OrdersPaginatedData, GetOrderHistoryParams> {
  final OrderRepository repository;

  GetOrderHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, OrdersPaginatedData>> call(
    GetOrderHistoryParams params,
  ) async {
    return await repository.getOrderHistory(
      perPage: params.perPage,
      page: params.page,
    );
  }
}

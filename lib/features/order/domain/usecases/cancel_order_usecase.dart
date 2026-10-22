import 'package:dartz/dartz.dart' hide Order;
import 'package:equatable/equatable.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/usecases/usecase.dart';
import 'package:food_user_app/features/order/domain/entities/order.dart';
import 'package:food_user_app/features/order/domain/repositories/order_repository.dart';

class CancelOrderParams extends Equatable {
  final String orderId;
  final String reason;

  const CancelOrderParams({
    required this.orderId,
    required this.reason,
  });

  @override
  List<Object?> get props => [orderId, reason];
}

class CancelOrderUseCase extends UseCase<Order, CancelOrderParams> {
  final OrderRepository repository;

  CancelOrderUseCase(this.repository);

  @override
  Future<Either<Failure, Order>> call(CancelOrderParams params) async {
    return await repository.cancelOrder(
      orderId: params.orderId,
      reason: params.reason,
    );
  }
}

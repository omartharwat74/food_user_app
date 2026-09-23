import 'package:dartz/dartz.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/usecases/usecase.dart';
import 'package:food_user_app/features/order/domain/entities/order_tracking.dart';
import 'package:food_user_app/features/order/domain/repositories/order_repository.dart';

class GetOrderTrackingUseCase extends UseCase<OrderTracking, String> {
  final OrderRepository repository;

  GetOrderTrackingUseCase(this.repository);

  @override
  Future<Either<Failure, OrderTracking>> call(String params) async {
    return await repository.trackOrder(params);
  }
}

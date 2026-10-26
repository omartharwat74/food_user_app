import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/usecases/usecase.dart';
import '../repositories/order_repository.dart';

class RateOrderParams extends Equatable {
  final int storeId;
  final int rating;
  final String? comment;
  final int? deliveryId;
  final int? deliveryRating;
  final String? deliveryComment;

  const RateOrderParams({
    required this.storeId,
    required this.rating,
    this.comment,
    this.deliveryId,
    this.deliveryRating,
    this.deliveryComment,
  });

  @override
  List<Object?> get props => [
        storeId,
        rating,
        comment,
        deliveryId,
        deliveryRating,
        deliveryComment,
      ];
}

class RateOrderUseCase extends UseCase<void, RateOrderParams> {
  final OrderRepository repository;

  RateOrderUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RateOrderParams params) {
    return repository.submitReview(
      storeId: params.storeId,
      rating: params.rating,
      comment: params.comment,
      deliveryId: params.deliveryId,
      deliveryRating: params.deliveryRating,
      deliveryComment: params.deliveryComment,
    );
  }
}

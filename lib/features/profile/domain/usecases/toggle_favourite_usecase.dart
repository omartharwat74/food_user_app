import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:food_user_app/features/restaurant/domain/repositories/restaurant_repository.dart';

class ToggleFavouriteParams extends Equatable {
  final String restaurantId;
  final bool isCurrentlyFavorite;

  const ToggleFavouriteParams({
    required this.restaurantId,
    required this.isCurrentlyFavorite,
  });

  @override
  List<Object?> get props => [restaurantId, isCurrentlyFavorite];
}

class ToggleFavouriteUseCase extends UseCase<Unit, ToggleFavouriteParams> {
  final RestaurantRepository repository;

  ToggleFavouriteUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ToggleFavouriteParams params) async {
    return await repository.toggleFavorite(params.restaurantId);
  }
}

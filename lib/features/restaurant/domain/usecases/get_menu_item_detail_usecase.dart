import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:food_user_app/features/restaurant/domain/repositories/menu_repository.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_item.dart';

class GetMenuItemDetailUseCase extends UseCase<MenuItem, String> {
  final MenuRepository repository;

  GetMenuItemDetailUseCase(this.repository);

  @override
  Future<Either<Failure, MenuItem>> call(String params) async {
    // There is no dedicated endpoint for menu item details. Items are passed from the list.
    // So this is just returning a stub or we can implement it by fetching modifiers if that's what's meant.
    // For now we'll return a Failure or we'll map to get modifiers instead.
    return Left(
      ServerFailure('Item details are fetched with the restaurant menu.'),
    );
  }
}

import 'package:dartz/dartz.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_category.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_item.dart';
import 'package:food_user_app/features/restaurant/domain/entities/modifier.dart';

abstract class MenuRepository {
  Future<Either<Failure, List<MenuCategory>>> getRestaurantMenu(
    String restaurantId,
  );

  Future<Either<Failure, List<MenuCategory>>> getBranchMenu(String branchId);

  Future<Either<Failure, List<Modifier>>> getItemModifiers(String itemId);

  /// Fetches menu from `/api/v1/stores/products/all?store_id={storeId}`.
  Future<Either<Failure, List<MenuCategory>>> getStoreMenu(String storeId);

  /// Fetches full product details from `/api/v1/stores/products/show?id={productId}`.
  Future<Either<Failure, MenuItem>> getProductDetail(String productId);
}

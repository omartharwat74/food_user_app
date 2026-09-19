import 'package:dartz/dartz.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/features/store/data/models/hyper_categories_response.dart';
import 'package:food_user_app/features/store/data/models/hyper_sections_response.dart';

abstract class StoreRepository {
  Future<Either<Failure, HyperCategoriesResponse>> getStoreCategories(String storeId);
  Future<Either<Failure, HyperSectionsResponse>> getStoreCategorySections({
    required String storeId,
    required String categoryId,
  });
}

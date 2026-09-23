import 'package:food_user_app/core/constants/app_assets.dart';

class CategoryIconHelper {
  /// Maps API category names to local Figma assets.
  /// You can export the 1x 2x 3x PNGs from Figma, place them in your assets folder,
  /// and map them here. If an image is missing, it will automatically use the fallback.
  static String getLocalCategoryIcon(String categoryName) {
    final name = categoryName.trim();

    if (name.contains('لحوم') || name == 'اللحوم') {
      return 'assets/images/categories/meat.png';
    } else if (name.contains('لبان') || name == 'الالبان' || name == 'ألبان') {
      return 'assets/images/categories/dairy.png';
    } else if (name.contains('كريم') ||
        name == 'ايس كريم' ||
        name == 'آيس كريم') {
      return 'assets/images/categories/ice_cream.png';
    } else if (name.contains('جبن') || name == 'الجبن') {
      return 'assets/images/categories/cheese.png';
    } else if (name.contains('بقول') || name == 'البقوليات') {
      return 'assets/images/categories/legumes.png';
    } else if (name.contains('مياه') ||
        name.contains('مياة') ||
        name.contains('غازي') ||
        name.contains('مشروب')) {
      return 'assets/images/categories/soda.png';
    } else if (name.contains('لكترون')) {
      return 'assets/images/categories/electronics.png';
    }

    return AppAssets.homeCategoryGrocery; // Default fallback
  }
}

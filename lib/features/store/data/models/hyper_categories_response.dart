import 'package:json_annotation/json_annotation.dart';

part 'hyper_categories_response.g.dart';

@JsonSerializable()
class HyperCategoriesResponse {
  @JsonKey(name: 'data')
  final HyperCategoriesData data;

  HyperCategoriesResponse({required this.data});

  factory HyperCategoriesResponse.fromJson(Map<String, dynamic> json) => _$HyperCategoriesResponseFromJson(json);
}

@JsonSerializable()
class HyperCategoriesData {
  @JsonKey(name: 'categories', defaultValue: [])
  final List<HyperCategory> categories;

  HyperCategoriesData({required this.categories});

  factory HyperCategoriesData.fromJson(Map<String, dynamic> json) => _$HyperCategoriesDataFromJson(json);
}

@JsonSerializable()
class HyperCategory {
  final dynamic id;
  @JsonKey(defaultValue: '')
  final String name;
  final String? image;

  HyperCategory({required this.id, required this.name, this.image});

  factory HyperCategory.fromJson(Map<String, dynamic> json) => _$HyperCategoryFromJson(json);
}

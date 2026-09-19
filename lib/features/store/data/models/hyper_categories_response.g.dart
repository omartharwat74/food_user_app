// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hyper_categories_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HyperCategoriesResponse _$HyperCategoriesResponseFromJson(
  Map<String, dynamic> json,
) => HyperCategoriesResponse(
  data: HyperCategoriesData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$HyperCategoriesResponseToJson(
  HyperCategoriesResponse instance,
) => <String, dynamic>{'data': instance.data};

HyperCategoriesData _$HyperCategoriesDataFromJson(Map<String, dynamic> json) =>
    HyperCategoriesData(
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => HyperCategory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$HyperCategoriesDataToJson(
  HyperCategoriesData instance,
) => <String, dynamic>{'categories': instance.categories};

HyperCategory _$HyperCategoryFromJson(Map<String, dynamic> json) =>
    HyperCategory(
      id: json['id'],
      name: json['name'] as String? ?? '',
      image: json['image'] as String?,
    );

Map<String, dynamic> _$HyperCategoryToJson(HyperCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
    };

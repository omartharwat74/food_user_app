// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hyper_sections_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HyperSectionsResponse _$HyperSectionsResponseFromJson(
  Map<String, dynamic> json,
) => HyperSectionsResponse(
  data: HyperSectionsData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$HyperSectionsResponseToJson(
  HyperSectionsResponse instance,
) => <String, dynamic>{'data': instance.data};

HyperSectionsData _$HyperSectionsDataFromJson(Map<String, dynamic> json) =>
    HyperSectionsData(
      sections:
          (json['sections'] as List<dynamic>?)
              ?.map((e) => HyperSection.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$HyperSectionsDataToJson(HyperSectionsData instance) =>
    <String, dynamic>{'sections': instance.sections};

HyperSection _$HyperSectionFromJson(Map<String, dynamic> json) => HyperSection(
  category: HyperCategory.fromJson(json['category'] as Map<String, dynamic>),
  products:
      (json['products'] as List<dynamic>?)
          ?.map((e) => HyperProduct.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$HyperSectionToJson(HyperSection instance) =>
    <String, dynamic>{
      'category': instance.category,
      'products': instance.products,
    };

HyperProduct _$HyperProductFromJson(Map<String, dynamic> json) => HyperProduct(
  id: json['id'],
  name: json['name'] as String? ?? '',
  description: json['description'] as String?,
  price: (json['price'] as num?)?.toDouble() ?? 0.0,
  priceAfterDiscount: (json['price_after_discount'] as num?)?.toDouble(),
  mainImage: json['main_image'] as String?,
  isAvailable: json['is_available'] == null
      ? true
      : const IntBoolConverter().fromJson(json['is_available']),
);

Map<String, dynamic> _$HyperProductToJson(HyperProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'price_after_discount': instance.priceAfterDiscount,
      'main_image': instance.mainImage,
      'is_available': const IntBoolConverter().toJson(instance.isAvailable),
    };

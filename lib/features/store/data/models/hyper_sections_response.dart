import 'package:json_annotation/json_annotation.dart';
import 'hyper_categories_response.dart';

part 'hyper_sections_response.g.dart';

@JsonSerializable()
class HyperSectionsResponse {
  @JsonKey(name: 'data')
  final HyperSectionsData data;

  HyperSectionsResponse({required this.data});

  factory HyperSectionsResponse.fromJson(Map<String, dynamic> json) => _$HyperSectionsResponseFromJson(json);
}

@JsonSerializable()
class HyperSectionsData {
  @JsonKey(name: 'sections', defaultValue: [])
  final List<HyperSection> sections;

  HyperSectionsData({required this.sections});

  factory HyperSectionsData.fromJson(Map<String, dynamic> json) => _$HyperSectionsDataFromJson(json);
}

@JsonSerializable()
class HyperSection {
  final HyperCategory category;
  @JsonKey(name: 'products', defaultValue: [])
  final List<HyperProduct> products;

  HyperSection({required this.category, required this.products});

  factory HyperSection.fromJson(Map<String, dynamic> json) => _$HyperSectionFromJson(json);
}

@JsonSerializable()
class HyperProduct {
  final dynamic id;
  @JsonKey(defaultValue: '')
  final String name;
  final String? description;
  @JsonKey(defaultValue: 0.0)
  final double price;
  @JsonKey(name: 'price_after_discount')
  final double? priceAfterDiscount;
  @JsonKey(name: 'main_image')
  final String? mainImage;
  @JsonKey(name: 'is_available', defaultValue: true)
  final bool isAvailable;

  HyperProduct({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.priceAfterDiscount,
    this.mainImage,
    this.isAvailable = true,
  });

  factory HyperProduct.fromJson(Map<String, dynamic> json) => _$HyperProductFromJson(json);
}

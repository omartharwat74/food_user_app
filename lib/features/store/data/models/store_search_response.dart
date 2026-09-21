import 'package:json_annotation/json_annotation.dart';
import 'hyper_sections_response.dart';

import 'package:food_user_app/core/utils/bool_converter.dart';

part 'store_search_response.g.dart';

@JsonSerializable()
class StoreSearchResponse {
  @JsonKey(name: 'data')
  final StoreSearchData data;

  @JsonKey(name: 'meta')
  final StoreSearchMeta? meta;

  StoreSearchResponse({required this.data, this.meta});

  factory StoreSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$StoreSearchResponseFromJson(json);
}

@JsonSerializable()
class StoreSearchData {
  @JsonKey(name: 'items', defaultValue: [])
  final List<HyperProduct> products;

  StoreSearchData({required this.products});

  factory StoreSearchData.fromJson(Map<String, dynamic> json) =>
      _$StoreSearchDataFromJson(json);
}

@JsonSerializable()
class StoreSearchMeta {
  @JsonKey(name: 'is_random', defaultValue: false)
  @IntBoolConverter()
  final bool isRandom;

  @JsonKey(name: 'current_page')
  final int? currentPage;

  @JsonKey(name: 'last_page')
  final int? lastPage;

  @JsonKey(name: 'total')
  final int? total;

  StoreSearchMeta({
    this.isRandom = false,
    this.currentPage,
    this.lastPage,
    this.total,
  });

  factory StoreSearchMeta.fromJson(Map<String, dynamic> json) =>
      _$StoreSearchMetaFromJson(json);
}

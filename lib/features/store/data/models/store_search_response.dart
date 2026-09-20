import 'package:json_annotation/json_annotation.dart';
import 'hyper_sections_response.dart';

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

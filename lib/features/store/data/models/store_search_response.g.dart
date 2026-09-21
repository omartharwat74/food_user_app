// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreSearchResponse _$StoreSearchResponseFromJson(Map<String, dynamic> json) =>
    StoreSearchResponse(
      data: StoreSearchData.fromJson(json['data'] as Map<String, dynamic>),
      meta: json['meta'] == null
          ? null
          : StoreSearchMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StoreSearchResponseToJson(
  StoreSearchResponse instance,
) => <String, dynamic>{'data': instance.data, 'meta': instance.meta};

StoreSearchData _$StoreSearchDataFromJson(Map<String, dynamic> json) =>
    StoreSearchData(
      products:
          (json['items'] as List<dynamic>?)
              ?.map((e) => HyperProduct.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$StoreSearchDataToJson(StoreSearchData instance) =>
    <String, dynamic>{'items': instance.products};

StoreSearchMeta _$StoreSearchMetaFromJson(Map<String, dynamic> json) =>
    StoreSearchMeta(
      isRandom: json['is_random'] == null
          ? false
          : const IntBoolConverter().fromJson(json['is_random']),
      currentPage: (json['current_page'] as num?)?.toInt(),
      lastPage: (json['last_page'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StoreSearchMetaToJson(StoreSearchMeta instance) =>
    <String, dynamic>{
      'is_random': const IntBoolConverter().toJson(instance.isRandom),
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'total': instance.total,
    };

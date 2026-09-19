// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'restaurant_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RestaurantDto {

@JsonKey(fromJson: _idFromJson) String get id; String? get name; String? get cuisineType; String? get coverImageUrl; double? get rating;@JsonKey(name: 'rating_avg') dynamic get ratingAvg;@JsonKey(name: 'rating_count') int? get ratingCount;@JsonKey(name: 'prep_time_from') int? get deliveryTimeMin;@JsonKey(name: 'prep_time_to') int? get deliveryTimeMax;@JsonKey(name: 'delivery_fee') double? get deliveryFee;@JsonKey(name: 'is_favorited') bool? get isFavorited;@JsonKey(name: 'logo') String? get logoUrl;@JsonKey(name: 'cover') String? get coverUrl; String? get description;@JsonKey(name: 'is_available') bool? get isAvailable;@JsonKey(name: 'is_open') bool? get isOpen;@JsonKey(name: 'is_major', fromJson: parseBoolFromJson) bool? get isMajor;
/// Create a copy of RestaurantDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RestaurantDtoCopyWith<RestaurantDto> get copyWith => _$RestaurantDtoCopyWithImpl<RestaurantDto>(this as RestaurantDto, _$identity);

  /// Serializes this RestaurantDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RestaurantDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.cuisineType, cuisineType) || other.cuisineType == cuisineType)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&(identical(other.rating, rating) || other.rating == rating)&&const DeepCollectionEquality().equals(other.ratingAvg, ratingAvg)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.deliveryTimeMin, deliveryTimeMin) || other.deliveryTimeMin == deliveryTimeMin)&&(identical(other.deliveryTimeMax, deliveryTimeMax) || other.deliveryTimeMax == deliveryTimeMax)&&(identical(other.deliveryFee, deliveryFee) || other.deliveryFee == deliveryFee)&&(identical(other.isFavorited, isFavorited) || other.isFavorited == isFavorited)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.isOpen, isOpen) || other.isOpen == isOpen)&&(identical(other.isMajor, isMajor) || other.isMajor == isMajor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,cuisineType,coverImageUrl,rating,const DeepCollectionEquality().hash(ratingAvg),ratingCount,deliveryTimeMin,deliveryTimeMax,deliveryFee,isFavorited,logoUrl,coverUrl,description,isAvailable,isOpen,isMajor);

@override
String toString() {
  return 'RestaurantDto(id: $id, name: $name, cuisineType: $cuisineType, coverImageUrl: $coverImageUrl, rating: $rating, ratingAvg: $ratingAvg, ratingCount: $ratingCount, deliveryTimeMin: $deliveryTimeMin, deliveryTimeMax: $deliveryTimeMax, deliveryFee: $deliveryFee, isFavorited: $isFavorited, logoUrl: $logoUrl, coverUrl: $coverUrl, description: $description, isAvailable: $isAvailable, isOpen: $isOpen, isMajor: $isMajor)';
}


}

/// @nodoc
abstract mixin class $RestaurantDtoCopyWith<$Res>  {
  factory $RestaurantDtoCopyWith(RestaurantDto value, $Res Function(RestaurantDto) _then) = _$RestaurantDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _idFromJson) String id, String? name, String? cuisineType, String? coverImageUrl, double? rating,@JsonKey(name: 'rating_avg') dynamic ratingAvg,@JsonKey(name: 'rating_count') int? ratingCount,@JsonKey(name: 'prep_time_from') int? deliveryTimeMin,@JsonKey(name: 'prep_time_to') int? deliveryTimeMax,@JsonKey(name: 'delivery_fee') double? deliveryFee,@JsonKey(name: 'is_favorited') bool? isFavorited,@JsonKey(name: 'logo') String? logoUrl,@JsonKey(name: 'cover') String? coverUrl, String? description,@JsonKey(name: 'is_available') bool? isAvailable,@JsonKey(name: 'is_open') bool? isOpen,@JsonKey(name: 'is_major', fromJson: parseBoolFromJson) bool? isMajor
});




}
/// @nodoc
class _$RestaurantDtoCopyWithImpl<$Res>
    implements $RestaurantDtoCopyWith<$Res> {
  _$RestaurantDtoCopyWithImpl(this._self, this._then);

  final RestaurantDto _self;
  final $Res Function(RestaurantDto) _then;

/// Create a copy of RestaurantDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,Object? cuisineType = freezed,Object? coverImageUrl = freezed,Object? rating = freezed,Object? ratingAvg = freezed,Object? ratingCount = freezed,Object? deliveryTimeMin = freezed,Object? deliveryTimeMax = freezed,Object? deliveryFee = freezed,Object? isFavorited = freezed,Object? logoUrl = freezed,Object? coverUrl = freezed,Object? description = freezed,Object? isAvailable = freezed,Object? isOpen = freezed,Object? isMajor = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,cuisineType: freezed == cuisineType ? _self.cuisineType : cuisineType // ignore: cast_nullable_to_non_nullable
as String?,coverImageUrl: freezed == coverImageUrl ? _self.coverImageUrl : coverImageUrl // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,ratingAvg: freezed == ratingAvg ? _self.ratingAvg : ratingAvg // ignore: cast_nullable_to_non_nullable
as dynamic,ratingCount: freezed == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int?,deliveryTimeMin: freezed == deliveryTimeMin ? _self.deliveryTimeMin : deliveryTimeMin // ignore: cast_nullable_to_non_nullable
as int?,deliveryTimeMax: freezed == deliveryTimeMax ? _self.deliveryTimeMax : deliveryTimeMax // ignore: cast_nullable_to_non_nullable
as int?,deliveryFee: freezed == deliveryFee ? _self.deliveryFee : deliveryFee // ignore: cast_nullable_to_non_nullable
as double?,isFavorited: freezed == isFavorited ? _self.isFavorited : isFavorited // ignore: cast_nullable_to_non_nullable
as bool?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isAvailable: freezed == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool?,isOpen: freezed == isOpen ? _self.isOpen : isOpen // ignore: cast_nullable_to_non_nullable
as bool?,isMajor: freezed == isMajor ? _self.isMajor : isMajor // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [RestaurantDto].
extension RestaurantDtoPatterns on RestaurantDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RestaurantDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RestaurantDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RestaurantDto value)  $default,){
final _that = this;
switch (_that) {
case _RestaurantDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RestaurantDto value)?  $default,){
final _that = this;
switch (_that) {
case _RestaurantDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idFromJson)  String id,  String? name,  String? cuisineType,  String? coverImageUrl,  double? rating, @JsonKey(name: 'rating_avg')  dynamic ratingAvg, @JsonKey(name: 'rating_count')  int? ratingCount, @JsonKey(name: 'prep_time_from')  int? deliveryTimeMin, @JsonKey(name: 'prep_time_to')  int? deliveryTimeMax, @JsonKey(name: 'delivery_fee')  double? deliveryFee, @JsonKey(name: 'is_favorited')  bool? isFavorited, @JsonKey(name: 'logo')  String? logoUrl, @JsonKey(name: 'cover')  String? coverUrl,  String? description, @JsonKey(name: 'is_available')  bool? isAvailable, @JsonKey(name: 'is_open')  bool? isOpen, @JsonKey(name: 'is_major', fromJson: parseBoolFromJson)  bool? isMajor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RestaurantDto() when $default != null:
return $default(_that.id,_that.name,_that.cuisineType,_that.coverImageUrl,_that.rating,_that.ratingAvg,_that.ratingCount,_that.deliveryTimeMin,_that.deliveryTimeMax,_that.deliveryFee,_that.isFavorited,_that.logoUrl,_that.coverUrl,_that.description,_that.isAvailable,_that.isOpen,_that.isMajor);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idFromJson)  String id,  String? name,  String? cuisineType,  String? coverImageUrl,  double? rating, @JsonKey(name: 'rating_avg')  dynamic ratingAvg, @JsonKey(name: 'rating_count')  int? ratingCount, @JsonKey(name: 'prep_time_from')  int? deliveryTimeMin, @JsonKey(name: 'prep_time_to')  int? deliveryTimeMax, @JsonKey(name: 'delivery_fee')  double? deliveryFee, @JsonKey(name: 'is_favorited')  bool? isFavorited, @JsonKey(name: 'logo')  String? logoUrl, @JsonKey(name: 'cover')  String? coverUrl,  String? description, @JsonKey(name: 'is_available')  bool? isAvailable, @JsonKey(name: 'is_open')  bool? isOpen, @JsonKey(name: 'is_major', fromJson: parseBoolFromJson)  bool? isMajor)  $default,) {final _that = this;
switch (_that) {
case _RestaurantDto():
return $default(_that.id,_that.name,_that.cuisineType,_that.coverImageUrl,_that.rating,_that.ratingAvg,_that.ratingCount,_that.deliveryTimeMin,_that.deliveryTimeMax,_that.deliveryFee,_that.isFavorited,_that.logoUrl,_that.coverUrl,_that.description,_that.isAvailable,_that.isOpen,_that.isMajor);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _idFromJson)  String id,  String? name,  String? cuisineType,  String? coverImageUrl,  double? rating, @JsonKey(name: 'rating_avg')  dynamic ratingAvg, @JsonKey(name: 'rating_count')  int? ratingCount, @JsonKey(name: 'prep_time_from')  int? deliveryTimeMin, @JsonKey(name: 'prep_time_to')  int? deliveryTimeMax, @JsonKey(name: 'delivery_fee')  double? deliveryFee, @JsonKey(name: 'is_favorited')  bool? isFavorited, @JsonKey(name: 'logo')  String? logoUrl, @JsonKey(name: 'cover')  String? coverUrl,  String? description, @JsonKey(name: 'is_available')  bool? isAvailable, @JsonKey(name: 'is_open')  bool? isOpen, @JsonKey(name: 'is_major', fromJson: parseBoolFromJson)  bool? isMajor)?  $default,) {final _that = this;
switch (_that) {
case _RestaurantDto() when $default != null:
return $default(_that.id,_that.name,_that.cuisineType,_that.coverImageUrl,_that.rating,_that.ratingAvg,_that.ratingCount,_that.deliveryTimeMin,_that.deliveryTimeMax,_that.deliveryFee,_that.isFavorited,_that.logoUrl,_that.coverUrl,_that.description,_that.isAvailable,_that.isOpen,_that.isMajor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RestaurantDto implements RestaurantDto {
  const _RestaurantDto({@JsonKey(fromJson: _idFromJson) this.id = '', this.name, this.cuisineType, this.coverImageUrl, this.rating, @JsonKey(name: 'rating_avg') this.ratingAvg, @JsonKey(name: 'rating_count') this.ratingCount, @JsonKey(name: 'prep_time_from') this.deliveryTimeMin, @JsonKey(name: 'prep_time_to') this.deliveryTimeMax, @JsonKey(name: 'delivery_fee') this.deliveryFee, @JsonKey(name: 'is_favorited') this.isFavorited, @JsonKey(name: 'logo') this.logoUrl, @JsonKey(name: 'cover') this.coverUrl, this.description, @JsonKey(name: 'is_available') this.isAvailable, @JsonKey(name: 'is_open') this.isOpen, @JsonKey(name: 'is_major', fromJson: parseBoolFromJson) this.isMajor});
  factory _RestaurantDto.fromJson(Map<String, dynamic> json) => _$RestaurantDtoFromJson(json);

@override@JsonKey(fromJson: _idFromJson) final  String id;
@override final  String? name;
@override final  String? cuisineType;
@override final  String? coverImageUrl;
@override final  double? rating;
@override@JsonKey(name: 'rating_avg') final  dynamic ratingAvg;
@override@JsonKey(name: 'rating_count') final  int? ratingCount;
@override@JsonKey(name: 'prep_time_from') final  int? deliveryTimeMin;
@override@JsonKey(name: 'prep_time_to') final  int? deliveryTimeMax;
@override@JsonKey(name: 'delivery_fee') final  double? deliveryFee;
@override@JsonKey(name: 'is_favorited') final  bool? isFavorited;
@override@JsonKey(name: 'logo') final  String? logoUrl;
@override@JsonKey(name: 'cover') final  String? coverUrl;
@override final  String? description;
@override@JsonKey(name: 'is_available') final  bool? isAvailable;
@override@JsonKey(name: 'is_open') final  bool? isOpen;
@override@JsonKey(name: 'is_major', fromJson: parseBoolFromJson) final  bool? isMajor;

/// Create a copy of RestaurantDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RestaurantDtoCopyWith<_RestaurantDto> get copyWith => __$RestaurantDtoCopyWithImpl<_RestaurantDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RestaurantDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RestaurantDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.cuisineType, cuisineType) || other.cuisineType == cuisineType)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&(identical(other.rating, rating) || other.rating == rating)&&const DeepCollectionEquality().equals(other.ratingAvg, ratingAvg)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.deliveryTimeMin, deliveryTimeMin) || other.deliveryTimeMin == deliveryTimeMin)&&(identical(other.deliveryTimeMax, deliveryTimeMax) || other.deliveryTimeMax == deliveryTimeMax)&&(identical(other.deliveryFee, deliveryFee) || other.deliveryFee == deliveryFee)&&(identical(other.isFavorited, isFavorited) || other.isFavorited == isFavorited)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.isOpen, isOpen) || other.isOpen == isOpen)&&(identical(other.isMajor, isMajor) || other.isMajor == isMajor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,cuisineType,coverImageUrl,rating,const DeepCollectionEquality().hash(ratingAvg),ratingCount,deliveryTimeMin,deliveryTimeMax,deliveryFee,isFavorited,logoUrl,coverUrl,description,isAvailable,isOpen,isMajor);

@override
String toString() {
  return 'RestaurantDto(id: $id, name: $name, cuisineType: $cuisineType, coverImageUrl: $coverImageUrl, rating: $rating, ratingAvg: $ratingAvg, ratingCount: $ratingCount, deliveryTimeMin: $deliveryTimeMin, deliveryTimeMax: $deliveryTimeMax, deliveryFee: $deliveryFee, isFavorited: $isFavorited, logoUrl: $logoUrl, coverUrl: $coverUrl, description: $description, isAvailable: $isAvailable, isOpen: $isOpen, isMajor: $isMajor)';
}


}

/// @nodoc
abstract mixin class _$RestaurantDtoCopyWith<$Res> implements $RestaurantDtoCopyWith<$Res> {
  factory _$RestaurantDtoCopyWith(_RestaurantDto value, $Res Function(_RestaurantDto) _then) = __$RestaurantDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _idFromJson) String id, String? name, String? cuisineType, String? coverImageUrl, double? rating,@JsonKey(name: 'rating_avg') dynamic ratingAvg,@JsonKey(name: 'rating_count') int? ratingCount,@JsonKey(name: 'prep_time_from') int? deliveryTimeMin,@JsonKey(name: 'prep_time_to') int? deliveryTimeMax,@JsonKey(name: 'delivery_fee') double? deliveryFee,@JsonKey(name: 'is_favorited') bool? isFavorited,@JsonKey(name: 'logo') String? logoUrl,@JsonKey(name: 'cover') String? coverUrl, String? description,@JsonKey(name: 'is_available') bool? isAvailable,@JsonKey(name: 'is_open') bool? isOpen,@JsonKey(name: 'is_major', fromJson: parseBoolFromJson) bool? isMajor
});




}
/// @nodoc
class __$RestaurantDtoCopyWithImpl<$Res>
    implements _$RestaurantDtoCopyWith<$Res> {
  __$RestaurantDtoCopyWithImpl(this._self, this._then);

  final _RestaurantDto _self;
  final $Res Function(_RestaurantDto) _then;

/// Create a copy of RestaurantDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,Object? cuisineType = freezed,Object? coverImageUrl = freezed,Object? rating = freezed,Object? ratingAvg = freezed,Object? ratingCount = freezed,Object? deliveryTimeMin = freezed,Object? deliveryTimeMax = freezed,Object? deliveryFee = freezed,Object? isFavorited = freezed,Object? logoUrl = freezed,Object? coverUrl = freezed,Object? description = freezed,Object? isAvailable = freezed,Object? isOpen = freezed,Object? isMajor = freezed,}) {
  return _then(_RestaurantDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,cuisineType: freezed == cuisineType ? _self.cuisineType : cuisineType // ignore: cast_nullable_to_non_nullable
as String?,coverImageUrl: freezed == coverImageUrl ? _self.coverImageUrl : coverImageUrl // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,ratingAvg: freezed == ratingAvg ? _self.ratingAvg : ratingAvg // ignore: cast_nullable_to_non_nullable
as dynamic,ratingCount: freezed == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int?,deliveryTimeMin: freezed == deliveryTimeMin ? _self.deliveryTimeMin : deliveryTimeMin // ignore: cast_nullable_to_non_nullable
as int?,deliveryTimeMax: freezed == deliveryTimeMax ? _self.deliveryTimeMax : deliveryTimeMax // ignore: cast_nullable_to_non_nullable
as int?,deliveryFee: freezed == deliveryFee ? _self.deliveryFee : deliveryFee // ignore: cast_nullable_to_non_nullable
as double?,isFavorited: freezed == isFavorited ? _self.isFavorited : isFavorited // ignore: cast_nullable_to_non_nullable
as bool?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isAvailable: freezed == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool?,isOpen: freezed == isOpen ? _self.isOpen : isOpen // ignore: cast_nullable_to_non_nullable
as bool?,isMajor: freezed == isMajor ? _self.isMajor : isMajor // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on

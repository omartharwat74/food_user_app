// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'menu_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MenuItemDto {

@JsonKey(fromJson: _idFromJson) String get id;@JsonKey(name: 'categoryId', fromJson: _nullableIdFromJson) String? get categoryId; String? get name; String? get description;@JsonKey(name: 'price_after_discount') double? get priceAfterDiscount; double? get price;@JsonKey(name: 'base_price') double? get basePrice; double? get originalPrice;@JsonKey(name: 'main_image') String? get mainImage; String? get imageUrl;@IntBoolConverter() bool? get available; Map<String, dynamic>? get offer;
/// Create a copy of MenuItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MenuItemDtoCopyWith<MenuItemDto> get copyWith => _$MenuItemDtoCopyWithImpl<MenuItemDto>(this as MenuItemDto, _$identity);

  /// Serializes this MenuItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MenuItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.priceAfterDiscount, priceAfterDiscount) || other.priceAfterDiscount == priceAfterDiscount)&&(identical(other.price, price) || other.price == price)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.mainImage, mainImage) || other.mainImage == mainImage)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.available, available) || other.available == available)&&const DeepCollectionEquality().equals(other.offer, offer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,categoryId,name,description,priceAfterDiscount,price,basePrice,originalPrice,mainImage,imageUrl,available,const DeepCollectionEquality().hash(offer));

@override
String toString() {
  return 'MenuItemDto(id: $id, categoryId: $categoryId, name: $name, description: $description, priceAfterDiscount: $priceAfterDiscount, price: $price, basePrice: $basePrice, originalPrice: $originalPrice, mainImage: $mainImage, imageUrl: $imageUrl, available: $available, offer: $offer)';
}


}

/// @nodoc
abstract mixin class $MenuItemDtoCopyWith<$Res>  {
  factory $MenuItemDtoCopyWith(MenuItemDto value, $Res Function(MenuItemDto) _then) = _$MenuItemDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _idFromJson) String id,@JsonKey(name: 'categoryId', fromJson: _nullableIdFromJson) String? categoryId, String? name, String? description,@JsonKey(name: 'price_after_discount') double? priceAfterDiscount, double? price,@JsonKey(name: 'base_price') double? basePrice, double? originalPrice,@JsonKey(name: 'main_image') String? mainImage, String? imageUrl,@IntBoolConverter() bool? available, Map<String, dynamic>? offer
});




}
/// @nodoc
class _$MenuItemDtoCopyWithImpl<$Res>
    implements $MenuItemDtoCopyWith<$Res> {
  _$MenuItemDtoCopyWithImpl(this._self, this._then);

  final MenuItemDto _self;
  final $Res Function(MenuItemDto) _then;

/// Create a copy of MenuItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? categoryId = freezed,Object? name = freezed,Object? description = freezed,Object? priceAfterDiscount = freezed,Object? price = freezed,Object? basePrice = freezed,Object? originalPrice = freezed,Object? mainImage = freezed,Object? imageUrl = freezed,Object? available = freezed,Object? offer = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,priceAfterDiscount: freezed == priceAfterDiscount ? _self.priceAfterDiscount : priceAfterDiscount // ignore: cast_nullable_to_non_nullable
as double?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,basePrice: freezed == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as double?,originalPrice: freezed == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double?,mainImage: freezed == mainImage ? _self.mainImage : mainImage // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,available: freezed == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool?,offer: freezed == offer ? _self.offer : offer // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [MenuItemDto].
extension MenuItemDtoPatterns on MenuItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MenuItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MenuItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MenuItemDto value)  $default,){
final _that = this;
switch (_that) {
case _MenuItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MenuItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _MenuItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idFromJson)  String id, @JsonKey(name: 'categoryId', fromJson: _nullableIdFromJson)  String? categoryId,  String? name,  String? description, @JsonKey(name: 'price_after_discount')  double? priceAfterDiscount,  double? price, @JsonKey(name: 'base_price')  double? basePrice,  double? originalPrice, @JsonKey(name: 'main_image')  String? mainImage,  String? imageUrl, @IntBoolConverter()  bool? available,  Map<String, dynamic>? offer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MenuItemDto() when $default != null:
return $default(_that.id,_that.categoryId,_that.name,_that.description,_that.priceAfterDiscount,_that.price,_that.basePrice,_that.originalPrice,_that.mainImage,_that.imageUrl,_that.available,_that.offer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idFromJson)  String id, @JsonKey(name: 'categoryId', fromJson: _nullableIdFromJson)  String? categoryId,  String? name,  String? description, @JsonKey(name: 'price_after_discount')  double? priceAfterDiscount,  double? price, @JsonKey(name: 'base_price')  double? basePrice,  double? originalPrice, @JsonKey(name: 'main_image')  String? mainImage,  String? imageUrl, @IntBoolConverter()  bool? available,  Map<String, dynamic>? offer)  $default,) {final _that = this;
switch (_that) {
case _MenuItemDto():
return $default(_that.id,_that.categoryId,_that.name,_that.description,_that.priceAfterDiscount,_that.price,_that.basePrice,_that.originalPrice,_that.mainImage,_that.imageUrl,_that.available,_that.offer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _idFromJson)  String id, @JsonKey(name: 'categoryId', fromJson: _nullableIdFromJson)  String? categoryId,  String? name,  String? description, @JsonKey(name: 'price_after_discount')  double? priceAfterDiscount,  double? price, @JsonKey(name: 'base_price')  double? basePrice,  double? originalPrice, @JsonKey(name: 'main_image')  String? mainImage,  String? imageUrl, @IntBoolConverter()  bool? available,  Map<String, dynamic>? offer)?  $default,) {final _that = this;
switch (_that) {
case _MenuItemDto() when $default != null:
return $default(_that.id,_that.categoryId,_that.name,_that.description,_that.priceAfterDiscount,_that.price,_that.basePrice,_that.originalPrice,_that.mainImage,_that.imageUrl,_that.available,_that.offer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MenuItemDto implements MenuItemDto {
  const _MenuItemDto({@JsonKey(fromJson: _idFromJson) this.id = '', @JsonKey(name: 'categoryId', fromJson: _nullableIdFromJson) this.categoryId, this.name, this.description, @JsonKey(name: 'price_after_discount') this.priceAfterDiscount, this.price, @JsonKey(name: 'base_price') this.basePrice, this.originalPrice, @JsonKey(name: 'main_image') this.mainImage, this.imageUrl, @IntBoolConverter() this.available, final  Map<String, dynamic>? offer}): _offer = offer;
  factory _MenuItemDto.fromJson(Map<String, dynamic> json) => _$MenuItemDtoFromJson(json);

@override@JsonKey(fromJson: _idFromJson) final  String id;
@override@JsonKey(name: 'categoryId', fromJson: _nullableIdFromJson) final  String? categoryId;
@override final  String? name;
@override final  String? description;
@override@JsonKey(name: 'price_after_discount') final  double? priceAfterDiscount;
@override final  double? price;
@override@JsonKey(name: 'base_price') final  double? basePrice;
@override final  double? originalPrice;
@override@JsonKey(name: 'main_image') final  String? mainImage;
@override final  String? imageUrl;
@override@IntBoolConverter() final  bool? available;
 final  Map<String, dynamic>? _offer;
@override Map<String, dynamic>? get offer {
  final value = _offer;
  if (value == null) return null;
  if (_offer is EqualUnmodifiableMapView) return _offer;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of MenuItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MenuItemDtoCopyWith<_MenuItemDto> get copyWith => __$MenuItemDtoCopyWithImpl<_MenuItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MenuItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MenuItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.priceAfterDiscount, priceAfterDiscount) || other.priceAfterDiscount == priceAfterDiscount)&&(identical(other.price, price) || other.price == price)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.mainImage, mainImage) || other.mainImage == mainImage)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.available, available) || other.available == available)&&const DeepCollectionEquality().equals(other._offer, _offer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,categoryId,name,description,priceAfterDiscount,price,basePrice,originalPrice,mainImage,imageUrl,available,const DeepCollectionEquality().hash(_offer));

@override
String toString() {
  return 'MenuItemDto(id: $id, categoryId: $categoryId, name: $name, description: $description, priceAfterDiscount: $priceAfterDiscount, price: $price, basePrice: $basePrice, originalPrice: $originalPrice, mainImage: $mainImage, imageUrl: $imageUrl, available: $available, offer: $offer)';
}


}

/// @nodoc
abstract mixin class _$MenuItemDtoCopyWith<$Res> implements $MenuItemDtoCopyWith<$Res> {
  factory _$MenuItemDtoCopyWith(_MenuItemDto value, $Res Function(_MenuItemDto) _then) = __$MenuItemDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _idFromJson) String id,@JsonKey(name: 'categoryId', fromJson: _nullableIdFromJson) String? categoryId, String? name, String? description,@JsonKey(name: 'price_after_discount') double? priceAfterDiscount, double? price,@JsonKey(name: 'base_price') double? basePrice, double? originalPrice,@JsonKey(name: 'main_image') String? mainImage, String? imageUrl,@IntBoolConverter() bool? available, Map<String, dynamic>? offer
});




}
/// @nodoc
class __$MenuItemDtoCopyWithImpl<$Res>
    implements _$MenuItemDtoCopyWith<$Res> {
  __$MenuItemDtoCopyWithImpl(this._self, this._then);

  final _MenuItemDto _self;
  final $Res Function(_MenuItemDto) _then;

/// Create a copy of MenuItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? categoryId = freezed,Object? name = freezed,Object? description = freezed,Object? priceAfterDiscount = freezed,Object? price = freezed,Object? basePrice = freezed,Object? originalPrice = freezed,Object? mainImage = freezed,Object? imageUrl = freezed,Object? available = freezed,Object? offer = freezed,}) {
  return _then(_MenuItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,priceAfterDiscount: freezed == priceAfterDiscount ? _self.priceAfterDiscount : priceAfterDiscount // ignore: cast_nullable_to_non_nullable
as double?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,basePrice: freezed == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as double?,originalPrice: freezed == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double?,mainImage: freezed == mainImage ? _self.mainImage : mainImage // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,available: freezed == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool?,offer: freezed == offer ? _self._offer : offer // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on

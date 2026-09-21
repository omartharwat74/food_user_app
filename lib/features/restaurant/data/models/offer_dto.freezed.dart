// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offer_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OfferDto {

@JsonKey(fromJson: _idFromJson) String get id;@JsonKey(name: 'restaurantId', fromJson: _nullableIdFromJson) String? get restaurantId; String? get title; int? get discountPercent; double? get minOrderAmount; String? get description; String? get expiresAt;@IntBoolConverter() bool? get active;
/// Create a copy of OfferDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfferDtoCopyWith<OfferDto> get copyWith => _$OfferDtoCopyWithImpl<OfferDto>(this as OfferDto, _$identity);

  /// Serializes this OfferDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfferDto&&(identical(other.id, id) || other.id == id)&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.title, title) || other.title == title)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent)&&(identical(other.minOrderAmount, minOrderAmount) || other.minOrderAmount == minOrderAmount)&&(identical(other.description, description) || other.description == description)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,restaurantId,title,discountPercent,minOrderAmount,description,expiresAt,active);

@override
String toString() {
  return 'OfferDto(id: $id, restaurantId: $restaurantId, title: $title, discountPercent: $discountPercent, minOrderAmount: $minOrderAmount, description: $description, expiresAt: $expiresAt, active: $active)';
}


}

/// @nodoc
abstract mixin class $OfferDtoCopyWith<$Res>  {
  factory $OfferDtoCopyWith(OfferDto value, $Res Function(OfferDto) _then) = _$OfferDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _idFromJson) String id,@JsonKey(name: 'restaurantId', fromJson: _nullableIdFromJson) String? restaurantId, String? title, int? discountPercent, double? minOrderAmount, String? description, String? expiresAt,@IntBoolConverter() bool? active
});




}
/// @nodoc
class _$OfferDtoCopyWithImpl<$Res>
    implements $OfferDtoCopyWith<$Res> {
  _$OfferDtoCopyWithImpl(this._self, this._then);

  final OfferDto _self;
  final $Res Function(OfferDto) _then;

/// Create a copy of OfferDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? restaurantId = freezed,Object? title = freezed,Object? discountPercent = freezed,Object? minOrderAmount = freezed,Object? description = freezed,Object? expiresAt = freezed,Object? active = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,restaurantId: freezed == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,discountPercent: freezed == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as int?,minOrderAmount: freezed == minOrderAmount ? _self.minOrderAmount : minOrderAmount // ignore: cast_nullable_to_non_nullable
as double?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String?,active: freezed == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [OfferDto].
extension OfferDtoPatterns on OfferDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OfferDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OfferDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OfferDto value)  $default,){
final _that = this;
switch (_that) {
case _OfferDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OfferDto value)?  $default,){
final _that = this;
switch (_that) {
case _OfferDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idFromJson)  String id, @JsonKey(name: 'restaurantId', fromJson: _nullableIdFromJson)  String? restaurantId,  String? title,  int? discountPercent,  double? minOrderAmount,  String? description,  String? expiresAt, @IntBoolConverter()  bool? active)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OfferDto() when $default != null:
return $default(_that.id,_that.restaurantId,_that.title,_that.discountPercent,_that.minOrderAmount,_that.description,_that.expiresAt,_that.active);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idFromJson)  String id, @JsonKey(name: 'restaurantId', fromJson: _nullableIdFromJson)  String? restaurantId,  String? title,  int? discountPercent,  double? minOrderAmount,  String? description,  String? expiresAt, @IntBoolConverter()  bool? active)  $default,) {final _that = this;
switch (_that) {
case _OfferDto():
return $default(_that.id,_that.restaurantId,_that.title,_that.discountPercent,_that.minOrderAmount,_that.description,_that.expiresAt,_that.active);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _idFromJson)  String id, @JsonKey(name: 'restaurantId', fromJson: _nullableIdFromJson)  String? restaurantId,  String? title,  int? discountPercent,  double? minOrderAmount,  String? description,  String? expiresAt, @IntBoolConverter()  bool? active)?  $default,) {final _that = this;
switch (_that) {
case _OfferDto() when $default != null:
return $default(_that.id,_that.restaurantId,_that.title,_that.discountPercent,_that.minOrderAmount,_that.description,_that.expiresAt,_that.active);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OfferDto implements OfferDto {
  const _OfferDto({@JsonKey(fromJson: _idFromJson) this.id = '', @JsonKey(name: 'restaurantId', fromJson: _nullableIdFromJson) this.restaurantId, this.title, this.discountPercent, this.minOrderAmount, this.description, this.expiresAt, @IntBoolConverter() this.active});
  factory _OfferDto.fromJson(Map<String, dynamic> json) => _$OfferDtoFromJson(json);

@override@JsonKey(fromJson: _idFromJson) final  String id;
@override@JsonKey(name: 'restaurantId', fromJson: _nullableIdFromJson) final  String? restaurantId;
@override final  String? title;
@override final  int? discountPercent;
@override final  double? minOrderAmount;
@override final  String? description;
@override final  String? expiresAt;
@override@IntBoolConverter() final  bool? active;

/// Create a copy of OfferDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfferDtoCopyWith<_OfferDto> get copyWith => __$OfferDtoCopyWithImpl<_OfferDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OfferDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OfferDto&&(identical(other.id, id) || other.id == id)&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.title, title) || other.title == title)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent)&&(identical(other.minOrderAmount, minOrderAmount) || other.minOrderAmount == minOrderAmount)&&(identical(other.description, description) || other.description == description)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,restaurantId,title,discountPercent,minOrderAmount,description,expiresAt,active);

@override
String toString() {
  return 'OfferDto(id: $id, restaurantId: $restaurantId, title: $title, discountPercent: $discountPercent, minOrderAmount: $minOrderAmount, description: $description, expiresAt: $expiresAt, active: $active)';
}


}

/// @nodoc
abstract mixin class _$OfferDtoCopyWith<$Res> implements $OfferDtoCopyWith<$Res> {
  factory _$OfferDtoCopyWith(_OfferDto value, $Res Function(_OfferDto) _then) = __$OfferDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _idFromJson) String id,@JsonKey(name: 'restaurantId', fromJson: _nullableIdFromJson) String? restaurantId, String? title, int? discountPercent, double? minOrderAmount, String? description, String? expiresAt,@IntBoolConverter() bool? active
});




}
/// @nodoc
class __$OfferDtoCopyWithImpl<$Res>
    implements _$OfferDtoCopyWith<$Res> {
  __$OfferDtoCopyWithImpl(this._self, this._then);

  final _OfferDto _self;
  final $Res Function(_OfferDto) _then;

/// Create a copy of OfferDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? restaurantId = freezed,Object? title = freezed,Object? discountPercent = freezed,Object? minOrderAmount = freezed,Object? description = freezed,Object? expiresAt = freezed,Object? active = freezed,}) {
  return _then(_OfferDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,restaurantId: freezed == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,discountPercent: freezed == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as int?,minOrderAmount: freezed == minOrderAmount ? _self.minOrderAmount : minOrderAmount // ignore: cast_nullable_to_non_nullable
as double?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String?,active: freezed == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on

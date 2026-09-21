// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'branch_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BranchDto {

@JsonKey(fromJson: _idFromJson) String get id;@JsonKey(name: 'restaurantId', fromJson: _nullableIdFromJson) String? get restaurantId; String? get address; double? get lat; double? get lng; Map<String, dynamic>? get operatingHours;@IntBoolConverter() bool? get active;
/// Create a copy of BranchDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BranchDtoCopyWith<BranchDto> get copyWith => _$BranchDtoCopyWithImpl<BranchDto>(this as BranchDto, _$identity);

  /// Serializes this BranchDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BranchDto&&(identical(other.id, id) || other.id == id)&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.address, address) || other.address == address)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&const DeepCollectionEquality().equals(other.operatingHours, operatingHours)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,restaurantId,address,lat,lng,const DeepCollectionEquality().hash(operatingHours),active);

@override
String toString() {
  return 'BranchDto(id: $id, restaurantId: $restaurantId, address: $address, lat: $lat, lng: $lng, operatingHours: $operatingHours, active: $active)';
}


}

/// @nodoc
abstract mixin class $BranchDtoCopyWith<$Res>  {
  factory $BranchDtoCopyWith(BranchDto value, $Res Function(BranchDto) _then) = _$BranchDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _idFromJson) String id,@JsonKey(name: 'restaurantId', fromJson: _nullableIdFromJson) String? restaurantId, String? address, double? lat, double? lng, Map<String, dynamic>? operatingHours,@IntBoolConverter() bool? active
});




}
/// @nodoc
class _$BranchDtoCopyWithImpl<$Res>
    implements $BranchDtoCopyWith<$Res> {
  _$BranchDtoCopyWithImpl(this._self, this._then);

  final BranchDto _self;
  final $Res Function(BranchDto) _then;

/// Create a copy of BranchDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? restaurantId = freezed,Object? address = freezed,Object? lat = freezed,Object? lng = freezed,Object? operatingHours = freezed,Object? active = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,restaurantId: freezed == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,operatingHours: freezed == operatingHours ? _self.operatingHours : operatingHours // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,active: freezed == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [BranchDto].
extension BranchDtoPatterns on BranchDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BranchDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BranchDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BranchDto value)  $default,){
final _that = this;
switch (_that) {
case _BranchDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BranchDto value)?  $default,){
final _that = this;
switch (_that) {
case _BranchDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idFromJson)  String id, @JsonKey(name: 'restaurantId', fromJson: _nullableIdFromJson)  String? restaurantId,  String? address,  double? lat,  double? lng,  Map<String, dynamic>? operatingHours, @IntBoolConverter()  bool? active)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BranchDto() when $default != null:
return $default(_that.id,_that.restaurantId,_that.address,_that.lat,_that.lng,_that.operatingHours,_that.active);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idFromJson)  String id, @JsonKey(name: 'restaurantId', fromJson: _nullableIdFromJson)  String? restaurantId,  String? address,  double? lat,  double? lng,  Map<String, dynamic>? operatingHours, @IntBoolConverter()  bool? active)  $default,) {final _that = this;
switch (_that) {
case _BranchDto():
return $default(_that.id,_that.restaurantId,_that.address,_that.lat,_that.lng,_that.operatingHours,_that.active);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _idFromJson)  String id, @JsonKey(name: 'restaurantId', fromJson: _nullableIdFromJson)  String? restaurantId,  String? address,  double? lat,  double? lng,  Map<String, dynamic>? operatingHours, @IntBoolConverter()  bool? active)?  $default,) {final _that = this;
switch (_that) {
case _BranchDto() when $default != null:
return $default(_that.id,_that.restaurantId,_that.address,_that.lat,_that.lng,_that.operatingHours,_that.active);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BranchDto implements BranchDto {
  const _BranchDto({@JsonKey(fromJson: _idFromJson) this.id = '', @JsonKey(name: 'restaurantId', fromJson: _nullableIdFromJson) this.restaurantId, this.address, this.lat, this.lng, final  Map<String, dynamic>? operatingHours, @IntBoolConverter() this.active}): _operatingHours = operatingHours;
  factory _BranchDto.fromJson(Map<String, dynamic> json) => _$BranchDtoFromJson(json);

@override@JsonKey(fromJson: _idFromJson) final  String id;
@override@JsonKey(name: 'restaurantId', fromJson: _nullableIdFromJson) final  String? restaurantId;
@override final  String? address;
@override final  double? lat;
@override final  double? lng;
 final  Map<String, dynamic>? _operatingHours;
@override Map<String, dynamic>? get operatingHours {
  final value = _operatingHours;
  if (value == null) return null;
  if (_operatingHours is EqualUnmodifiableMapView) return _operatingHours;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@IntBoolConverter() final  bool? active;

/// Create a copy of BranchDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BranchDtoCopyWith<_BranchDto> get copyWith => __$BranchDtoCopyWithImpl<_BranchDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BranchDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BranchDto&&(identical(other.id, id) || other.id == id)&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.address, address) || other.address == address)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&const DeepCollectionEquality().equals(other._operatingHours, _operatingHours)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,restaurantId,address,lat,lng,const DeepCollectionEquality().hash(_operatingHours),active);

@override
String toString() {
  return 'BranchDto(id: $id, restaurantId: $restaurantId, address: $address, lat: $lat, lng: $lng, operatingHours: $operatingHours, active: $active)';
}


}

/// @nodoc
abstract mixin class _$BranchDtoCopyWith<$Res> implements $BranchDtoCopyWith<$Res> {
  factory _$BranchDtoCopyWith(_BranchDto value, $Res Function(_BranchDto) _then) = __$BranchDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _idFromJson) String id,@JsonKey(name: 'restaurantId', fromJson: _nullableIdFromJson) String? restaurantId, String? address, double? lat, double? lng, Map<String, dynamic>? operatingHours,@IntBoolConverter() bool? active
});




}
/// @nodoc
class __$BranchDtoCopyWithImpl<$Res>
    implements _$BranchDtoCopyWith<$Res> {
  __$BranchDtoCopyWithImpl(this._self, this._then);

  final _BranchDto _self;
  final $Res Function(_BranchDto) _then;

/// Create a copy of BranchDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? restaurantId = freezed,Object? address = freezed,Object? lat = freezed,Object? lng = freezed,Object? operatingHours = freezed,Object? active = freezed,}) {
  return _then(_BranchDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,restaurantId: freezed == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,operatingHours: freezed == operatingHours ? _self._operatingHours : operatingHours // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,active: freezed == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on

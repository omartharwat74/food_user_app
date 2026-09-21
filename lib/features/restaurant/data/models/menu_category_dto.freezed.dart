// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'menu_category_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MenuCategoryDto {

@JsonKey(fromJson: _idFromJson) String get id;@JsonKey(name: 'branchId', fromJson: _idFromJson) String get branchId; String? get name; int get sortOrder; List<MenuItemDto> get items;@IntBoolConverter() bool get visible;
/// Create a copy of MenuCategoryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MenuCategoryDtoCopyWith<MenuCategoryDto> get copyWith => _$MenuCategoryDtoCopyWithImpl<MenuCategoryDto>(this as MenuCategoryDto, _$identity);

  /// Serializes this MenuCategoryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MenuCategoryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.name, name) || other.name == name)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.visible, visible) || other.visible == visible));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,branchId,name,sortOrder,const DeepCollectionEquality().hash(items),visible);

@override
String toString() {
  return 'MenuCategoryDto(id: $id, branchId: $branchId, name: $name, sortOrder: $sortOrder, items: $items, visible: $visible)';
}


}

/// @nodoc
abstract mixin class $MenuCategoryDtoCopyWith<$Res>  {
  factory $MenuCategoryDtoCopyWith(MenuCategoryDto value, $Res Function(MenuCategoryDto) _then) = _$MenuCategoryDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _idFromJson) String id,@JsonKey(name: 'branchId', fromJson: _idFromJson) String branchId, String? name, int sortOrder, List<MenuItemDto> items,@IntBoolConverter() bool visible
});




}
/// @nodoc
class _$MenuCategoryDtoCopyWithImpl<$Res>
    implements $MenuCategoryDtoCopyWith<$Res> {
  _$MenuCategoryDtoCopyWithImpl(this._self, this._then);

  final MenuCategoryDto _self;
  final $Res Function(MenuCategoryDto) _then;

/// Create a copy of MenuCategoryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? branchId = null,Object? name = freezed,Object? sortOrder = null,Object? items = null,Object? visible = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MenuItemDto>,visible: null == visible ? _self.visible : visible // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MenuCategoryDto].
extension MenuCategoryDtoPatterns on MenuCategoryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MenuCategoryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MenuCategoryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MenuCategoryDto value)  $default,){
final _that = this;
switch (_that) {
case _MenuCategoryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MenuCategoryDto value)?  $default,){
final _that = this;
switch (_that) {
case _MenuCategoryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idFromJson)  String id, @JsonKey(name: 'branchId', fromJson: _idFromJson)  String branchId,  String? name,  int sortOrder,  List<MenuItemDto> items, @IntBoolConverter()  bool visible)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MenuCategoryDto() when $default != null:
return $default(_that.id,_that.branchId,_that.name,_that.sortOrder,_that.items,_that.visible);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idFromJson)  String id, @JsonKey(name: 'branchId', fromJson: _idFromJson)  String branchId,  String? name,  int sortOrder,  List<MenuItemDto> items, @IntBoolConverter()  bool visible)  $default,) {final _that = this;
switch (_that) {
case _MenuCategoryDto():
return $default(_that.id,_that.branchId,_that.name,_that.sortOrder,_that.items,_that.visible);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _idFromJson)  String id, @JsonKey(name: 'branchId', fromJson: _idFromJson)  String branchId,  String? name,  int sortOrder,  List<MenuItemDto> items, @IntBoolConverter()  bool visible)?  $default,) {final _that = this;
switch (_that) {
case _MenuCategoryDto() when $default != null:
return $default(_that.id,_that.branchId,_that.name,_that.sortOrder,_that.items,_that.visible);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MenuCategoryDto implements MenuCategoryDto {
  const _MenuCategoryDto({@JsonKey(fromJson: _idFromJson) this.id = '', @JsonKey(name: 'branchId', fromJson: _idFromJson) this.branchId = '', this.name, this.sortOrder = 0, final  List<MenuItemDto> items = const [], @IntBoolConverter() this.visible = true}): _items = items;
  factory _MenuCategoryDto.fromJson(Map<String, dynamic> json) => _$MenuCategoryDtoFromJson(json);

@override@JsonKey(fromJson: _idFromJson) final  String id;
@override@JsonKey(name: 'branchId', fromJson: _idFromJson) final  String branchId;
@override final  String? name;
@override@JsonKey() final  int sortOrder;
 final  List<MenuItemDto> _items;
@override@JsonKey() List<MenuItemDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey()@IntBoolConverter() final  bool visible;

/// Create a copy of MenuCategoryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MenuCategoryDtoCopyWith<_MenuCategoryDto> get copyWith => __$MenuCategoryDtoCopyWithImpl<_MenuCategoryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MenuCategoryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MenuCategoryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.name, name) || other.name == name)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.visible, visible) || other.visible == visible));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,branchId,name,sortOrder,const DeepCollectionEquality().hash(_items),visible);

@override
String toString() {
  return 'MenuCategoryDto(id: $id, branchId: $branchId, name: $name, sortOrder: $sortOrder, items: $items, visible: $visible)';
}


}

/// @nodoc
abstract mixin class _$MenuCategoryDtoCopyWith<$Res> implements $MenuCategoryDtoCopyWith<$Res> {
  factory _$MenuCategoryDtoCopyWith(_MenuCategoryDto value, $Res Function(_MenuCategoryDto) _then) = __$MenuCategoryDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _idFromJson) String id,@JsonKey(name: 'branchId', fromJson: _idFromJson) String branchId, String? name, int sortOrder, List<MenuItemDto> items,@IntBoolConverter() bool visible
});




}
/// @nodoc
class __$MenuCategoryDtoCopyWithImpl<$Res>
    implements _$MenuCategoryDtoCopyWith<$Res> {
  __$MenuCategoryDtoCopyWithImpl(this._self, this._then);

  final _MenuCategoryDto _self;
  final $Res Function(_MenuCategoryDto) _then;

/// Create a copy of MenuCategoryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? branchId = null,Object? name = freezed,Object? sortOrder = null,Object? items = null,Object? visible = null,}) {
  return _then(_MenuCategoryDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MenuItemDto>,visible: null == visible ? _self.visible : visible // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page_response_restaurant_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PageResponseRestaurantDto {

 List<RestaurantDto> get content; int get page; int get size; int get totalElements; int get totalPages;@IntBoolConverter() bool get last;
/// Create a copy of PageResponseRestaurantDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PageResponseRestaurantDtoCopyWith<PageResponseRestaurantDto> get copyWith => _$PageResponseRestaurantDtoCopyWithImpl<PageResponseRestaurantDto>(this as PageResponseRestaurantDto, _$identity);

  /// Serializes this PageResponseRestaurantDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PageResponseRestaurantDto&&const DeepCollectionEquality().equals(other.content, content)&&(identical(other.page, page) || other.page == page)&&(identical(other.size, size) || other.size == size)&&(identical(other.totalElements, totalElements) || other.totalElements == totalElements)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.last, last) || other.last == last));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(content),page,size,totalElements,totalPages,last);

@override
String toString() {
  return 'PageResponseRestaurantDto(content: $content, page: $page, size: $size, totalElements: $totalElements, totalPages: $totalPages, last: $last)';
}


}

/// @nodoc
abstract mixin class $PageResponseRestaurantDtoCopyWith<$Res>  {
  factory $PageResponseRestaurantDtoCopyWith(PageResponseRestaurantDto value, $Res Function(PageResponseRestaurantDto) _then) = _$PageResponseRestaurantDtoCopyWithImpl;
@useResult
$Res call({
 List<RestaurantDto> content, int page, int size, int totalElements, int totalPages,@IntBoolConverter() bool last
});




}
/// @nodoc
class _$PageResponseRestaurantDtoCopyWithImpl<$Res>
    implements $PageResponseRestaurantDtoCopyWith<$Res> {
  _$PageResponseRestaurantDtoCopyWithImpl(this._self, this._then);

  final PageResponseRestaurantDto _self;
  final $Res Function(PageResponseRestaurantDto) _then;

/// Create a copy of PageResponseRestaurantDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,Object? page = null,Object? size = null,Object? totalElements = null,Object? totalPages = null,Object? last = null,}) {
  return _then(_self.copyWith(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as List<RestaurantDto>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,totalElements: null == totalElements ? _self.totalElements : totalElements // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,last: null == last ? _self.last : last // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PageResponseRestaurantDto].
extension PageResponseRestaurantDtoPatterns on PageResponseRestaurantDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PageResponseRestaurantDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PageResponseRestaurantDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PageResponseRestaurantDto value)  $default,){
final _that = this;
switch (_that) {
case _PageResponseRestaurantDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PageResponseRestaurantDto value)?  $default,){
final _that = this;
switch (_that) {
case _PageResponseRestaurantDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<RestaurantDto> content,  int page,  int size,  int totalElements,  int totalPages, @IntBoolConverter()  bool last)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PageResponseRestaurantDto() when $default != null:
return $default(_that.content,_that.page,_that.size,_that.totalElements,_that.totalPages,_that.last);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<RestaurantDto> content,  int page,  int size,  int totalElements,  int totalPages, @IntBoolConverter()  bool last)  $default,) {final _that = this;
switch (_that) {
case _PageResponseRestaurantDto():
return $default(_that.content,_that.page,_that.size,_that.totalElements,_that.totalPages,_that.last);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<RestaurantDto> content,  int page,  int size,  int totalElements,  int totalPages, @IntBoolConverter()  bool last)?  $default,) {final _that = this;
switch (_that) {
case _PageResponseRestaurantDto() when $default != null:
return $default(_that.content,_that.page,_that.size,_that.totalElements,_that.totalPages,_that.last);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PageResponseRestaurantDto implements PageResponseRestaurantDto {
  const _PageResponseRestaurantDto({final  List<RestaurantDto> content = const [], this.page = 0, this.size = 0, this.totalElements = 0, this.totalPages = 0, @IntBoolConverter() this.last = true}): _content = content;
  factory _PageResponseRestaurantDto.fromJson(Map<String, dynamic> json) => _$PageResponseRestaurantDtoFromJson(json);

 final  List<RestaurantDto> _content;
@override@JsonKey() List<RestaurantDto> get content {
  if (_content is EqualUnmodifiableListView) return _content;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_content);
}

@override@JsonKey() final  int page;
@override@JsonKey() final  int size;
@override@JsonKey() final  int totalElements;
@override@JsonKey() final  int totalPages;
@override@JsonKey()@IntBoolConverter() final  bool last;

/// Create a copy of PageResponseRestaurantDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PageResponseRestaurantDtoCopyWith<_PageResponseRestaurantDto> get copyWith => __$PageResponseRestaurantDtoCopyWithImpl<_PageResponseRestaurantDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PageResponseRestaurantDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PageResponseRestaurantDto&&const DeepCollectionEquality().equals(other._content, _content)&&(identical(other.page, page) || other.page == page)&&(identical(other.size, size) || other.size == size)&&(identical(other.totalElements, totalElements) || other.totalElements == totalElements)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.last, last) || other.last == last));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_content),page,size,totalElements,totalPages,last);

@override
String toString() {
  return 'PageResponseRestaurantDto(content: $content, page: $page, size: $size, totalElements: $totalElements, totalPages: $totalPages, last: $last)';
}


}

/// @nodoc
abstract mixin class _$PageResponseRestaurantDtoCopyWith<$Res> implements $PageResponseRestaurantDtoCopyWith<$Res> {
  factory _$PageResponseRestaurantDtoCopyWith(_PageResponseRestaurantDto value, $Res Function(_PageResponseRestaurantDto) _then) = __$PageResponseRestaurantDtoCopyWithImpl;
@override @useResult
$Res call({
 List<RestaurantDto> content, int page, int size, int totalElements, int totalPages,@IntBoolConverter() bool last
});




}
/// @nodoc
class __$PageResponseRestaurantDtoCopyWithImpl<$Res>
    implements _$PageResponseRestaurantDtoCopyWith<$Res> {
  __$PageResponseRestaurantDtoCopyWithImpl(this._self, this._then);

  final _PageResponseRestaurantDto _self;
  final $Res Function(_PageResponseRestaurantDto) _then;

/// Create a copy of PageResponseRestaurantDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? page = null,Object? size = null,Object? totalElements = null,Object? totalPages = null,Object? last = null,}) {
  return _then(_PageResponseRestaurantDto(
content: null == content ? _self._content : content // ignore: cast_nullable_to_non_nullable
as List<RestaurantDto>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,totalElements: null == totalElements ? _self.totalElements : totalElements // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,last: null == last ? _self.last : last // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

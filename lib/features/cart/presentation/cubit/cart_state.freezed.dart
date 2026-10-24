// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CartState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CartState()';
}


}

/// @nodoc
class $CartStateCopyWith<$Res>  {
$CartStateCopyWith(CartState _, $Res Function(CartState) __);
}


/// Adds pattern-matching-related methods to [CartState].
extension CartStatePatterns on CartState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Conflict value)?  conflict,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Conflict() when conflict != null:
return conflict(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Conflict value)  conflict,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Conflict():
return conflict(_that);case _Error():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Conflict value)?  conflict,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Conflict() when conflict != null:
return conflict(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( Cart cart,  Promo? appliedPromo,  int? updatingProductId)?  loaded,TResult Function( Cart cart,  String newRestaurantId,  String menuItemId,  String name,  int price,  int quantity,  List<Map<String, dynamic>>? selectedModifiers,  String? notes)?  conflict,TResult Function( Cart cart,  Promo? appliedPromo,  String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.cart,_that.appliedPromo,_that.updatingProductId);case _Conflict() when conflict != null:
return conflict(_that.cart,_that.newRestaurantId,_that.menuItemId,_that.name,_that.price,_that.quantity,_that.selectedModifiers,_that.notes);case _Error() when error != null:
return error(_that.cart,_that.appliedPromo,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( Cart cart,  Promo? appliedPromo,  int? updatingProductId)  loaded,required TResult Function( Cart cart,  String newRestaurantId,  String menuItemId,  String name,  int price,  int quantity,  List<Map<String, dynamic>>? selectedModifiers,  String? notes)  conflict,required TResult Function( Cart cart,  Promo? appliedPromo,  String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.cart,_that.appliedPromo,_that.updatingProductId);case _Conflict():
return conflict(_that.cart,_that.newRestaurantId,_that.menuItemId,_that.name,_that.price,_that.quantity,_that.selectedModifiers,_that.notes);case _Error():
return error(_that.cart,_that.appliedPromo,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( Cart cart,  Promo? appliedPromo,  int? updatingProductId)?  loaded,TResult? Function( Cart cart,  String newRestaurantId,  String menuItemId,  String name,  int price,  int quantity,  List<Map<String, dynamic>>? selectedModifiers,  String? notes)?  conflict,TResult? Function( Cart cart,  Promo? appliedPromo,  String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.cart,_that.appliedPromo,_that.updatingProductId);case _Conflict() when conflict != null:
return conflict(_that.cart,_that.newRestaurantId,_that.menuItemId,_that.name,_that.price,_that.quantity,_that.selectedModifiers,_that.notes);case _Error() when error != null:
return error(_that.cart,_that.appliedPromo,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements CartState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CartState.initial()';
}


}




/// @nodoc


class _Loading implements CartState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CartState.loading()';
}


}




/// @nodoc


class _Loaded implements CartState {
  const _Loaded({required this.cart, this.appliedPromo, this.updatingProductId});
  

 final  Cart cart;
 final  Promo? appliedPromo;
 final  int? updatingProductId;

/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.cart, cart) || other.cart == cart)&&(identical(other.appliedPromo, appliedPromo) || other.appliedPromo == appliedPromo)&&(identical(other.updatingProductId, updatingProductId) || other.updatingProductId == updatingProductId));
}


@override
int get hashCode => Object.hash(runtimeType,cart,appliedPromo,updatingProductId);

@override
String toString() {
  return 'CartState.loaded(cart: $cart, appliedPromo: $appliedPromo, updatingProductId: $updatingProductId)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $CartStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 Cart cart, Promo? appliedPromo, int? updatingProductId
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? cart = null,Object? appliedPromo = freezed,Object? updatingProductId = freezed,}) {
  return _then(_Loaded(
cart: null == cart ? _self.cart : cart // ignore: cast_nullable_to_non_nullable
as Cart,appliedPromo: freezed == appliedPromo ? _self.appliedPromo : appliedPromo // ignore: cast_nullable_to_non_nullable
as Promo?,updatingProductId: freezed == updatingProductId ? _self.updatingProductId : updatingProductId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class _Conflict implements CartState {
  const _Conflict({required this.cart, required this.newRestaurantId, required this.menuItemId, required this.name, required this.price, required this.quantity, final  List<Map<String, dynamic>>? selectedModifiers, this.notes}): _selectedModifiers = selectedModifiers;
  

 final  Cart cart;
 final  String newRestaurantId;
 final  String menuItemId;
 final  String name;
 final  int price;
 final  int quantity;
 final  List<Map<String, dynamic>>? _selectedModifiers;
 List<Map<String, dynamic>>? get selectedModifiers {
  final value = _selectedModifiers;
  if (value == null) return null;
  if (_selectedModifiers is EqualUnmodifiableListView) return _selectedModifiers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  String? notes;

/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConflictCopyWith<_Conflict> get copyWith => __$ConflictCopyWithImpl<_Conflict>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Conflict&&(identical(other.cart, cart) || other.cart == cart)&&(identical(other.newRestaurantId, newRestaurantId) || other.newRestaurantId == newRestaurantId)&&(identical(other.menuItemId, menuItemId) || other.menuItemId == menuItemId)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&const DeepCollectionEquality().equals(other._selectedModifiers, _selectedModifiers)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode => Object.hash(runtimeType,cart,newRestaurantId,menuItemId,name,price,quantity,const DeepCollectionEquality().hash(_selectedModifiers),notes);

@override
String toString() {
  return 'CartState.conflict(cart: $cart, newRestaurantId: $newRestaurantId, menuItemId: $menuItemId, name: $name, price: $price, quantity: $quantity, selectedModifiers: $selectedModifiers, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$ConflictCopyWith<$Res> implements $CartStateCopyWith<$Res> {
  factory _$ConflictCopyWith(_Conflict value, $Res Function(_Conflict) _then) = __$ConflictCopyWithImpl;
@useResult
$Res call({
 Cart cart, String newRestaurantId, String menuItemId, String name, int price, int quantity, List<Map<String, dynamic>>? selectedModifiers, String? notes
});




}
/// @nodoc
class __$ConflictCopyWithImpl<$Res>
    implements _$ConflictCopyWith<$Res> {
  __$ConflictCopyWithImpl(this._self, this._then);

  final _Conflict _self;
  final $Res Function(_Conflict) _then;

/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? cart = null,Object? newRestaurantId = null,Object? menuItemId = null,Object? name = null,Object? price = null,Object? quantity = null,Object? selectedModifiers = freezed,Object? notes = freezed,}) {
  return _then(_Conflict(
cart: null == cart ? _self.cart : cart // ignore: cast_nullable_to_non_nullable
as Cart,newRestaurantId: null == newRestaurantId ? _self.newRestaurantId : newRestaurantId // ignore: cast_nullable_to_non_nullable
as String,menuItemId: null == menuItemId ? _self.menuItemId : menuItemId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,selectedModifiers: freezed == selectedModifiers ? _self._selectedModifiers : selectedModifiers // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _Error implements CartState {
  const _Error({required this.cart, this.appliedPromo, required this.message});
  

 final  Cart cart;
 final  Promo? appliedPromo;
 final  String message;

/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.cart, cart) || other.cart == cart)&&(identical(other.appliedPromo, appliedPromo) || other.appliedPromo == appliedPromo)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,cart,appliedPromo,message);

@override
String toString() {
  return 'CartState.error(cart: $cart, appliedPromo: $appliedPromo, message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $CartStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 Cart cart, Promo? appliedPromo, String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? cart = null,Object? appliedPromo = freezed,Object? message = null,}) {
  return _then(_Error(
cart: null == cart ? _self.cart : cart // ignore: cast_nullable_to_non_nullable
as Cart,appliedPromo: freezed == appliedPromo ? _self.appliedPromo : appliedPromo // ignore: cast_nullable_to_non_nullable
as Promo?,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

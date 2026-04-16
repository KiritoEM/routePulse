// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signup_infos_credentials_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SignupInfosCredentialsState {

 String get email; String get fullName;
/// Create a copy of SignupInfosCredentialsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignupInfosCredentialsStateCopyWith<SignupInfosCredentialsState> get copyWith => _$SignupInfosCredentialsStateCopyWithImpl<SignupInfosCredentialsState>(this as SignupInfosCredentialsState, _$identity);

  /// Serializes this SignupInfosCredentialsState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignupInfosCredentialsState&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,fullName);

@override
String toString() {
  return 'SignupInfosCredentialsState(email: $email, fullName: $fullName)';
}


}

/// @nodoc
abstract mixin class $SignupInfosCredentialsStateCopyWith<$Res>  {
  factory $SignupInfosCredentialsStateCopyWith(SignupInfosCredentialsState value, $Res Function(SignupInfosCredentialsState) _then) = _$SignupInfosCredentialsStateCopyWithImpl;
@useResult
$Res call({
 String email, String fullName
});




}
/// @nodoc
class _$SignupInfosCredentialsStateCopyWithImpl<$Res>
    implements $SignupInfosCredentialsStateCopyWith<$Res> {
  _$SignupInfosCredentialsStateCopyWithImpl(this._self, this._then);

  final SignupInfosCredentialsState _self;
  final $Res Function(SignupInfosCredentialsState) _then;

/// Create a copy of SignupInfosCredentialsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? fullName = null,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SignupInfosCredentialsState].
extension SignupInfosCredentialsStatePatterns on SignupInfosCredentialsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SignupInfosCredentialsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SignupInfosCredentialsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SignupInfosCredentialsState value)  $default,){
final _that = this;
switch (_that) {
case _SignupInfosCredentialsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SignupInfosCredentialsState value)?  $default,){
final _that = this;
switch (_that) {
case _SignupInfosCredentialsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String fullName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SignupInfosCredentialsState() when $default != null:
return $default(_that.email,_that.fullName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String fullName)  $default,) {final _that = this;
switch (_that) {
case _SignupInfosCredentialsState():
return $default(_that.email,_that.fullName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String fullName)?  $default,) {final _that = this;
switch (_that) {
case _SignupInfosCredentialsState() when $default != null:
return $default(_that.email,_that.fullName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SignupInfosCredentialsState implements SignupInfosCredentialsState {
  const _SignupInfosCredentialsState({required this.email, required this.fullName});
  factory _SignupInfosCredentialsState.fromJson(Map<String, dynamic> json) => _$SignupInfosCredentialsStateFromJson(json);

@override final  String email;
@override final  String fullName;

/// Create a copy of SignupInfosCredentialsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignupInfosCredentialsStateCopyWith<_SignupInfosCredentialsState> get copyWith => __$SignupInfosCredentialsStateCopyWithImpl<_SignupInfosCredentialsState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SignupInfosCredentialsStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignupInfosCredentialsState&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,fullName);

@override
String toString() {
  return 'SignupInfosCredentialsState(email: $email, fullName: $fullName)';
}


}

/// @nodoc
abstract mixin class _$SignupInfosCredentialsStateCopyWith<$Res> implements $SignupInfosCredentialsStateCopyWith<$Res> {
  factory _$SignupInfosCredentialsStateCopyWith(_SignupInfosCredentialsState value, $Res Function(_SignupInfosCredentialsState) _then) = __$SignupInfosCredentialsStateCopyWithImpl;
@override @useResult
$Res call({
 String email, String fullName
});




}
/// @nodoc
class __$SignupInfosCredentialsStateCopyWithImpl<$Res>
    implements _$SignupInfosCredentialsStateCopyWith<$Res> {
  __$SignupInfosCredentialsStateCopyWithImpl(this._self, this._then);

  final _SignupInfosCredentialsState _self;
  final $Res Function(_SignupInfosCredentialsState) _then;

/// Create a copy of SignupInfosCredentialsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? fullName = null,}) {
  return _then(_SignupInfosCredentialsState(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

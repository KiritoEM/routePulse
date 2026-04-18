// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'validate_otp_credentials_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ValidateOtpCredentialsState {

 String get code; String get verificationToken;
/// Create a copy of ValidateOtpCredentialsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ValidateOtpCredentialsStateCopyWith<ValidateOtpCredentialsState> get copyWith => _$ValidateOtpCredentialsStateCopyWithImpl<ValidateOtpCredentialsState>(this as ValidateOtpCredentialsState, _$identity);

  /// Serializes this ValidateOtpCredentialsState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ValidateOtpCredentialsState&&(identical(other.code, code) || other.code == code)&&(identical(other.verificationToken, verificationToken) || other.verificationToken == verificationToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,verificationToken);

@override
String toString() {
  return 'ValidateOtpCredentialsState(code: $code, verificationToken: $verificationToken)';
}


}

/// @nodoc
abstract mixin class $ValidateOtpCredentialsStateCopyWith<$Res>  {
  factory $ValidateOtpCredentialsStateCopyWith(ValidateOtpCredentialsState value, $Res Function(ValidateOtpCredentialsState) _then) = _$ValidateOtpCredentialsStateCopyWithImpl;
@useResult
$Res call({
 String code, String verificationToken
});




}
/// @nodoc
class _$ValidateOtpCredentialsStateCopyWithImpl<$Res>
    implements $ValidateOtpCredentialsStateCopyWith<$Res> {
  _$ValidateOtpCredentialsStateCopyWithImpl(this._self, this._then);

  final ValidateOtpCredentialsState _self;
  final $Res Function(ValidateOtpCredentialsState) _then;

/// Create a copy of ValidateOtpCredentialsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? verificationToken = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,verificationToken: null == verificationToken ? _self.verificationToken : verificationToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ValidateOtpCredentialsState].
extension ValidateOtpCredentialsStatePatterns on ValidateOtpCredentialsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ValidateOtpCredentialsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ValidateOtpCredentialsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ValidateOtpCredentialsState value)  $default,){
final _that = this;
switch (_that) {
case _ValidateOtpCredentialsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ValidateOtpCredentialsState value)?  $default,){
final _that = this;
switch (_that) {
case _ValidateOtpCredentialsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String verificationToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ValidateOtpCredentialsState() when $default != null:
return $default(_that.code,_that.verificationToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String verificationToken)  $default,) {final _that = this;
switch (_that) {
case _ValidateOtpCredentialsState():
return $default(_that.code,_that.verificationToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String verificationToken)?  $default,) {final _that = this;
switch (_that) {
case _ValidateOtpCredentialsState() when $default != null:
return $default(_that.code,_that.verificationToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ValidateOtpCredentialsState implements ValidateOtpCredentialsState {
  const _ValidateOtpCredentialsState({required this.code, required this.verificationToken});
  factory _ValidateOtpCredentialsState.fromJson(Map<String, dynamic> json) => _$ValidateOtpCredentialsStateFromJson(json);

@override final  String code;
@override final  String verificationToken;

/// Create a copy of ValidateOtpCredentialsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ValidateOtpCredentialsStateCopyWith<_ValidateOtpCredentialsState> get copyWith => __$ValidateOtpCredentialsStateCopyWithImpl<_ValidateOtpCredentialsState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ValidateOtpCredentialsStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ValidateOtpCredentialsState&&(identical(other.code, code) || other.code == code)&&(identical(other.verificationToken, verificationToken) || other.verificationToken == verificationToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,verificationToken);

@override
String toString() {
  return 'ValidateOtpCredentialsState(code: $code, verificationToken: $verificationToken)';
}


}

/// @nodoc
abstract mixin class _$ValidateOtpCredentialsStateCopyWith<$Res> implements $ValidateOtpCredentialsStateCopyWith<$Res> {
  factory _$ValidateOtpCredentialsStateCopyWith(_ValidateOtpCredentialsState value, $Res Function(_ValidateOtpCredentialsState) _then) = __$ValidateOtpCredentialsStateCopyWithImpl;
@override @useResult
$Res call({
 String code, String verificationToken
});




}
/// @nodoc
class __$ValidateOtpCredentialsStateCopyWithImpl<$Res>
    implements _$ValidateOtpCredentialsStateCopyWith<$Res> {
  __$ValidateOtpCredentialsStateCopyWithImpl(this._self, this._then);

  final _ValidateOtpCredentialsState _self;
  final $Res Function(_ValidateOtpCredentialsState) _then;

/// Create a copy of ValidateOtpCredentialsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? verificationToken = null,}) {
  return _then(_ValidateOtpCredentialsState(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,verificationToken: null == verificationToken ? _self.verificationToken : verificationToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

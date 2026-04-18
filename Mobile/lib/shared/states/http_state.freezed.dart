// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'http_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HttpState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HttpState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HttpState()';
}


}

/// @nodoc
class $HttpStateCopyWith<$Res>  {
$HttpStateCopyWith(HttpState _, $Res Function(HttpState) __);
}


/// Adds pattern-matching-related methods to [HttpState].
extension HttpStatePatterns on HttpState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HttpInitial value)?  init,TResult Function( HttpLoading value)?  loading,TResult Function( HttpSuccess value)?  success,TResult Function( HttpError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HttpInitial() when init != null:
return init(_that);case HttpLoading() when loading != null:
return loading(_that);case HttpSuccess() when success != null:
return success(_that);case HttpError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HttpInitial value)  init,required TResult Function( HttpLoading value)  loading,required TResult Function( HttpSuccess value)  success,required TResult Function( HttpError value)  error,}){
final _that = this;
switch (_that) {
case HttpInitial():
return init(_that);case HttpLoading():
return loading(_that);case HttpSuccess():
return success(_that);case HttpError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HttpInitial value)?  init,TResult? Function( HttpLoading value)?  loading,TResult? Function( HttpSuccess value)?  success,TResult? Function( HttpError value)?  error,}){
final _that = this;
switch (_that) {
case HttpInitial() when init != null:
return init(_that);case HttpLoading() when loading != null:
return loading(_that);case HttpSuccess() when success != null:
return success(_that);case HttpError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  init,TResult Function()?  loading,TResult Function( String? message,  dynamic data)?  success,TResult Function( NetworkErrorType errorType,  String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HttpInitial() when init != null:
return init();case HttpLoading() when loading != null:
return loading();case HttpSuccess() when success != null:
return success(_that.message,_that.data);case HttpError() when error != null:
return error(_that.errorType,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  init,required TResult Function()  loading,required TResult Function( String? message,  dynamic data)  success,required TResult Function( NetworkErrorType errorType,  String message)  error,}) {final _that = this;
switch (_that) {
case HttpInitial():
return init();case HttpLoading():
return loading();case HttpSuccess():
return success(_that.message,_that.data);case HttpError():
return error(_that.errorType,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  init,TResult? Function()?  loading,TResult? Function( String? message,  dynamic data)?  success,TResult? Function( NetworkErrorType errorType,  String message)?  error,}) {final _that = this;
switch (_that) {
case HttpInitial() when init != null:
return init();case HttpLoading() when loading != null:
return loading();case HttpSuccess() when success != null:
return success(_that.message,_that.data);case HttpError() when error != null:
return error(_that.errorType,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class HttpInitial implements HttpState {
  const HttpInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HttpInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HttpState.init()';
}


}




/// @nodoc


class HttpLoading implements HttpState {
  const HttpLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HttpLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HttpState.loading()';
}


}




/// @nodoc


class HttpSuccess implements HttpState {
  const HttpSuccess({this.message, this.data});
  

 final  String? message;
 final  dynamic data;

/// Create a copy of HttpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HttpSuccessCopyWith<HttpSuccess> get copyWith => _$HttpSuccessCopyWithImpl<HttpSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HttpSuccess&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'HttpState.success(message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $HttpSuccessCopyWith<$Res> implements $HttpStateCopyWith<$Res> {
  factory $HttpSuccessCopyWith(HttpSuccess value, $Res Function(HttpSuccess) _then) = _$HttpSuccessCopyWithImpl;
@useResult
$Res call({
 String? message, dynamic data
});




}
/// @nodoc
class _$HttpSuccessCopyWithImpl<$Res>
    implements $HttpSuccessCopyWith<$Res> {
  _$HttpSuccessCopyWithImpl(this._self, this._then);

  final HttpSuccess _self;
  final $Res Function(HttpSuccess) _then;

/// Create a copy of HttpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,Object? data = freezed,}) {
  return _then(HttpSuccess(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

/// @nodoc


class HttpError implements HttpState {
  const HttpError({required this.errorType, required this.message});
  

 final  NetworkErrorType errorType;
 final  String message;

/// Create a copy of HttpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HttpErrorCopyWith<HttpError> get copyWith => _$HttpErrorCopyWithImpl<HttpError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HttpError&&(identical(other.errorType, errorType) || other.errorType == errorType)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,errorType,message);

@override
String toString() {
  return 'HttpState.error(errorType: $errorType, message: $message)';
}


}

/// @nodoc
abstract mixin class $HttpErrorCopyWith<$Res> implements $HttpStateCopyWith<$Res> {
  factory $HttpErrorCopyWith(HttpError value, $Res Function(HttpError) _then) = _$HttpErrorCopyWithImpl;
@useResult
$Res call({
 NetworkErrorType errorType, String message
});




}
/// @nodoc
class _$HttpErrorCopyWithImpl<$Res>
    implements $HttpErrorCopyWith<$Res> {
  _$HttpErrorCopyWithImpl(this._self, this._then);

  final HttpError _self;
  final $Res Function(HttpError) _then;

/// Create a copy of HttpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorType = null,Object? message = null,}) {
  return _then(HttpError(
errorType: null == errorType ? _self.errorType : errorType // ignore: cast_nullable_to_non_nullable
as NetworkErrorType,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

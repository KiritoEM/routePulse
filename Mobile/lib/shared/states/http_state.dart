import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_pulse_mobile/core/constants/enums/enums.dart';

part 'http_state.freezed.dart';

@freezed
abstract class HttpState with _$HttpState {
  const factory HttpState.init() = HttpInitial;
  const factory HttpState.loading() = HttpLoading;
  const factory HttpState.success() = HttpSuccess;
  const factory HttpState.error({required NetworkErrorType errorType, required String message}) =
      HttpError;
}

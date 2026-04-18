// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_validate_code_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SignupValidateCodeNotifier)
final signupValidateCodeProvider = SignupValidateCodeNotifierProvider._();

final class SignupValidateCodeNotifierProvider
    extends $NotifierProvider<SignupValidateCodeNotifier, HttpState> {
  SignupValidateCodeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signupValidateCodeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signupValidateCodeNotifierHash();

  @$internal
  @override
  SignupValidateCodeNotifier create() => SignupValidateCodeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HttpState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HttpState>(value),
    );
  }
}

String _$signupValidateCodeNotifierHash() =>
    r'5da9471001d85330cf43c2b1f59690b789ad70b2';

abstract class _$SignupValidateCodeNotifier extends $Notifier<HttpState> {
  HttpState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<HttpState, HttpState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HttpState, HttpState>,
              HttpState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

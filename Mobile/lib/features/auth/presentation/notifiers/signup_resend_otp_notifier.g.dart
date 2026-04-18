// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_resend_otp_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SignupResendOtpNotifier)
final signupResendOtpProvider = SignupResendOtpNotifierProvider._();

final class SignupResendOtpNotifierProvider
    extends $NotifierProvider<SignupResendOtpNotifier, HttpState> {
  SignupResendOtpNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signupResendOtpProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signupResendOtpNotifierHash();

  @$internal
  @override
  SignupResendOtpNotifier create() => SignupResendOtpNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HttpState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HttpState>(value),
    );
  }
}

String _$signupResendOtpNotifierHash() =>
    r'07568413e87e735568fd1603d317935ad894e7fe';

abstract class _$SignupResendOtpNotifier extends $Notifier<HttpState> {
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

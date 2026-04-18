// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_resend_otp_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SignupResendOtpNotifier)
final signupResendOtpProvider = SignupResendOtpNotifierFamily._();

final class SignupResendOtpNotifierProvider
    extends $NotifierProvider<SignupResendOtpNotifier, HttpState> {
  SignupResendOtpNotifierProvider._({
    required SignupResendOtpNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'signupResendOtpProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$signupResendOtpNotifierHash();

  @override
  String toString() {
    return r'signupResendOtpProvider'
        ''
        '($argument)';
  }

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

  @override
  bool operator ==(Object other) {
    return other is SignupResendOtpNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$signupResendOtpNotifierHash() =>
    r'3fec93fbfb846212f5a2ee81345da3d178c8bf99';

final class SignupResendOtpNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          SignupResendOtpNotifier,
          HttpState,
          HttpState,
          HttpState,
          String
        > {
  SignupResendOtpNotifierFamily._()
    : super(
        retry: null,
        name: r'signupResendOtpProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SignupResendOtpNotifierProvider call(String verificationToken) =>
      SignupResendOtpNotifierProvider._(
        argument: verificationToken,
        from: this,
      );

  @override
  String toString() => r'signupResendOtpProvider';
}

abstract class _$SignupResendOtpNotifier extends $Notifier<HttpState> {
  late final _$args = ref.$arg as String;
  String get verificationToken => _$args;

  HttpState build(String verificationToken);
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
    element.handleCreate(ref, () => build(_$args));
  }
}

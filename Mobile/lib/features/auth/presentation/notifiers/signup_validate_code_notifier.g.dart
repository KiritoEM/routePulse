// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_validate_code_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SignupValidateCodeNotifier)
final signupValidateCodeProvider = SignupValidateCodeNotifierFamily._();

final class SignupValidateCodeNotifierProvider
    extends $NotifierProvider<SignupValidateCodeNotifier, HttpState> {
  SignupValidateCodeNotifierProvider._({
    required SignupValidateCodeNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'signupValidateCodeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$signupValidateCodeNotifierHash();

  @override
  String toString() {
    return r'signupValidateCodeProvider'
        ''
        '($argument)';
  }

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

  @override
  bool operator ==(Object other) {
    return other is SignupValidateCodeNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$signupValidateCodeNotifierHash() =>
    r'58bb01e9305888d7116e112c0d28f1174bf129f3';

final class SignupValidateCodeNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          SignupValidateCodeNotifier,
          HttpState,
          HttpState,
          HttpState,
          String
        > {
  SignupValidateCodeNotifierFamily._()
    : super(
        retry: null,
        name: r'signupValidateCodeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SignupValidateCodeNotifierProvider call(String verificationToken) =>
      SignupValidateCodeNotifierProvider._(
        argument: verificationToken,
        from: this,
      );

  @override
  String toString() => r'signupValidateCodeProvider';
}

abstract class _$SignupValidateCodeNotifier extends $Notifier<HttpState> {
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

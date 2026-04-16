// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_infos_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SignupInfosNotifier)
final signupInfosProvider = SignupInfosNotifierProvider._();

final class SignupInfosNotifierProvider
    extends $NotifierProvider<SignupInfosNotifier, HttpState> {
  SignupInfosNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signupInfosProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signupInfosNotifierHash();

  @$internal
  @override
  SignupInfosNotifier create() => SignupInfosNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HttpState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HttpState>(value),
    );
  }
}

String _$signupInfosNotifierHash() =>
    r'61d4b7c7a1c5c2ec2128049fee1c8dd296157c24';

abstract class _$SignupInfosNotifier extends $Notifier<HttpState> {
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_countdown_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OtpCountdownNotifier)
final otpCountdownProvider = OtpCountdownNotifierProvider._();

final class OtpCountdownNotifierProvider
    extends $NotifierProvider<OtpCountdownNotifier, Duration> {
  OtpCountdownNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'otpCountdownProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$otpCountdownNotifierHash();

  @$internal
  @override
  OtpCountdownNotifier create() => OtpCountdownNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Duration>(value),
    );
  }
}

String _$otpCountdownNotifierHash() =>
    r'7fc95a8a958a2841557b5e5783fb0f4f3152904a';

abstract class _$OtpCountdownNotifier extends $Notifier<Duration> {
  Duration build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Duration, Duration>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Duration, Duration>,
              Duration,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

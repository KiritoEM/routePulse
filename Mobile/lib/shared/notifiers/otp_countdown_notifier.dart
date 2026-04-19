import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'otp_countdown_notifier.g.dart';

@riverpod
class OtpCountdownNotifier extends _$OtpCountdownNotifier {
  late Timer _timer;

  @override
  Duration build() {
    ref.onDispose(() => _timer.cancel());

    // start countdown
    _startTimer();

    return Duration(minutes: 5);
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state == Duration.zero) {
        timer.cancel();
        return;
      }

      state = state - Duration(seconds: 1);
    });
  }

  void resetTimer() {
    _timer.cancel();
    state = Duration(minutes: 5);
    _startTimer();
  }
}

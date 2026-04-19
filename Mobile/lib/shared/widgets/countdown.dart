import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/core/utils/duration_utils.dart';
import 'package:route_pulse_mobile/shared/notifiers/otp_countdown_notifier.dart';

class Countdown extends ConsumerWidget {
  const Countdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countdownState = ref.watch(otpCountdownProvider);
    final Map<String, dynamic> formatedTime =
        DurationUtils.formatDurationForDisplay(countdownState);
    final int minutes = formatedTime["minutes"];
    final int seconds = formatedTime["seconds"];

    return Text(
      '${minutes < 10 ? '0$minutes' : minutes}:${seconds < 10 ? '0$seconds' : seconds}',
      style: TextStyle(fontSize: AppTypography.h3),
    );
  }
}

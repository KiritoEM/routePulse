import 'package:flutter/cupertino.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';

class ErrorText extends StatelessWidget {
  final String message;

  const ErrorText(this.message);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4),
      child: Text(
        message,
        style: TextStyle(fontSize: 12, color: AppColors.error),
      ),
    );
  }
}

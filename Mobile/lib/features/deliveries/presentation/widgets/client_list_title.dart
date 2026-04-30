import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/shared/widgets/rectangle_avatar.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';

class ClientListTitle extends StatelessWidget {
  final String name;
  final String phoneNumber;

  const ClientListTitle({
    super.key,
    required this.name,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        name,
        style: TextStyle(fontSize: AppTypography.body + 1.5, fontWeight: .w500),
      ),
      subtitle: Text(
        phoneNumber,
        style: TextStyle(color: AppColors.mutedForeground),
      ),
      leading: RectangleAvatar(name: name),
      trailing: CustomIcon(path: 'assets/icons/call-calling.svg', width: 24),
    );
  }
}

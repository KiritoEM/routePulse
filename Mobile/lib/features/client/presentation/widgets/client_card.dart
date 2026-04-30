import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/shared/widgets/rectangle_avatar.dart';

class ClientCard extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String? address;
  final VoidCallback onTapMenu;

  const ClientCard({
    super.key,
    required this.name,
    required this.phoneNumber,
    this.address,
    required this.onTapMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: RectangleAvatar(name: name, width: 54, height: 54),
        title: Text(name, style: TextStyle(fontSize: AppTypography.body + 1)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),

            Text(
              phoneNumber,
              style: TextStyle(
                color: AppColors.mutedForeground,
                fontSize: AppTypography.small,
              ),
            ),

            if (address != null)
              Text(
                address!,
                style: TextStyle(
                  color: AppColors.mutedForeground,
                  fontSize: AppTypography.small,
                ),
              ),
          ],
        ),
        trailing: IconButton(
          onPressed: onTapMenu,
          icon: const Icon(Icons.more_vert_rounded),
        ),
      ),
    );
  }
}

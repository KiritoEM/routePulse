import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';
import 'package:route_pulse_mobile/shared/widgets/drawer_opener.dart';

class DeliveriesAppbar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onFilter;

  const DeliveriesAppbar({super.key, required this.onFilter});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 14),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Livraisons',
          style: TextStyle(fontSize: AppTypography.h3 - 1.5, fontWeight: .w500),
        ),
        actions: [
          IconButton(
            onPressed: () => onFilter(),
            icon: CustomIcon(path: 'assets/icons/sort.svg'),
          ),
          DrawerOpener(),
        ],
      ),
    );
  }
}

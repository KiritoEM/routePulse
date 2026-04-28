import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_pulse_mobile/core/constants/router_constant.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';

class DeliveryDetailsAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onOpenMenu;

  const DeliveryDetailsAppbar({super.key, required this.onOpenMenu});

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
        leading: IconButton(
          onPressed: () {
            context.canPop()
                ? context.pop(true)
                : context.go(RouterConstant.DELIVERIES_ROUTE);
          },
          icon: CustomIcon(path: 'assets/icons/chevron-left.svg', width: 28),
        ),
        title: Text(
          'Fiche de livraison',
          style: TextStyle(fontSize: AppTypography.h5, fontWeight: .w500),
        ),

        actions: [
          IconButton(
            onPressed: () => onOpenMenu(),
            icon: Icon(Icons.more_vert_sharp),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_pulse_mobile/core/constants/router_constant.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';

class DeliveryDetailsAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final bool showMenuIcon;
  final VoidCallback onOpenMenu;

  const DeliveryDetailsAppbar({
    super.key,
    required this.onOpenMenu,
    this.showMenuIcon = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.grayBg,
      elevation: 0,
      scrolledUnderElevation: 1.4,
      titleSpacing: 4,
      leading: Padding(
        child: IconButton(
          onPressed: () {
            context.canPop()
                ? context.pop(true)
                : context.go(RouterConstant.DELIVERIES_ROUTE);
          },
          icon: CustomIcon(path: 'assets/icons/chevron-left.svg', width: 28),
        ),
        padding: EdgeInsets.only(left: 16),
      ),
      title: Text(
        'Fiche de livraison',
        style: TextStyle(fontSize: AppTypography.h5, fontWeight: .w500),
      ),

      actions: [
        if (showMenuIcon)
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () => onOpenMenu(),
              icon: Icon(Icons.more_horiz_sharp),
            ),
          ),
      ],
    );
  }
}

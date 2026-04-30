import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:name_avatar/name_avatar.dart';
import 'package:route_pulse_mobile/core/constants/router_constant.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/features/auth/presentation/notifiers/current_user_notifier.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';

class MainAppDrawer extends ConsumerWidget {
  const MainAppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserState = ref.watch(currentUserProvider);

    String userName = 'Utilisateur';
    String userEmail = 'user@routepulse.fr';

    if (currentUserState is HttpSuccess && currentUserState.data != null) {
      userName = currentUserState.data?['name'] ?? 'Utilisateur';
      userEmail = currentUserState.data?['email'] ?? 'user@routepulse.fr';
    }

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  NameAvatar(
                    radius: 24,
                    isTwoChar: true,
                    backgroundColor: AppColors.info,
                    name: userName,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userEmail,
                          style: TextStyle(
                            fontSize: AppTypography.small,
                            color: AppColors.mutedForeground,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Divider(color: AppColors.divider),
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _DrawerItem(
                    label: 'Gérer les clients',
                    onPressed: () {
                      if (!context.mounted) return;

                      context.go(RouterConstant.CLIENT_ROUTE);
                      Navigator.pop(context);
                    },
                  ),
                  _DrawerItem(
                    label: 'Gérer les véhicules',
                    onPressed: () {
                      if (!context.mounted) return;

                      context.go(RouterConstant.VEHICLE_ROUTE);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Implémenter la déconnexion
                      // ref.read(authProvider.notifier).logout();
                    },
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIcon(
                          path: 'assets/icons/logout.svg',
                          color: AppColors.error,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Se déconnecter',
                          style: TextStyle(
                            fontSize: AppTypography.h5 - 1.5,
                            color: AppColors.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _DrawerItem({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      title: Text(
        label,
        style: TextStyle(
          fontSize: AppTypography.h5 - 1.5,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onPressed,
    );
  }
}

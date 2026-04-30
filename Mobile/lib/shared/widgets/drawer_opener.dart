import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:name_avatar/name_avatar.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/features/auth/presentation/notifiers/current_user_notifier.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';

class DrawerOpener extends ConsumerWidget {
  const DrawerOpener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserState = ref.watch(currentUserProvider);

    String userName = 'Utilisateur';
    if (currentUserState is HttpSuccess && currentUserState.data != null) {
      userName = currentUserState.data?['name'] ?? 'Utilisateur';
    }

    return GestureDetector(
      onTap: () => Scaffold.of(context).openDrawer(),
      child: currentUserState is HttpLoading
          ? const SkeletonLine(
              style: SkeletonLineStyle(
                height: 100,
                width: 100,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
            )
          : NameAvatar(
              name: userName,
              radius: 17,
              isTwoChar: true,
              backgroundColor: AppColors.info,
            ),
    );
  }
}

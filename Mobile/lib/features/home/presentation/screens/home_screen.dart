import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:name_avatar/name_avatar.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/features/home/presentation/widgets/next_deliveries_section.dart';
import 'package:route_pulse_mobile/features/home/presentation/widgets/quick_actions.dart';
import 'package:route_pulse_mobile/features/home/presentation/widgets/stat_card.dart';
import 'package:route_pulse_mobile/shared/widgets/app_bottom_navigation.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Padding(
          child: CustomIcon(
            path: 'assets/icons/route_pulse-logo.svg',
            color: AppColors.primary,
            width: 152,
          ),
          padding: EdgeInsets.only(left: 16),
        ),

        actions: [
          Padding(
            child: NameAvatar(
              name: 'Loick',
              radius: 16,
              isTwoChar: true,
              backgroundColor: AppColors.info,
            ),
            padding: EdgeInsets.only(right: 16),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          clipBehavior: .none,
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // stats cards
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 2,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: StatCard(
                          label: 'Livraisons à faire',
                          value: 5,
                          color: const Color(0xFF19C5FA),
                          icon: CustomIcon(
                            path: 'assets/icons/bicycle.svg',
                            width: 28,
                            color: const Color(0xFF19C5FA),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: StatCard(
                          label: 'Livraisons terminées',
                          value: 8,
                          color: const Color(0xFFD719FA),
                          icon: CustomIcon(
                            path: 'assets/icons/double-check.svg',
                            width: 28,
                            color: const Color(0xFFD719FA),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // quick actions
              QuickActions(),

              const SizedBox(height: 28),

              NextDeliveriesSection(),
            ],
          ),
        ),
      ),

       bottomNavigationBar: AppBottomNavigation(),
    );
  }
}
